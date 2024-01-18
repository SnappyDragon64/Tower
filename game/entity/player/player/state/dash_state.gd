extends PlayerState


var jump_queued := false


func _ready() -> void:
	await super._ready()


func _enter(_message = {}) -> void:
	player.velocity.y = 0.0
	player.can_attack = false
	player.play_animation("dash")
	$DashTimer.start()


func _state_physics_process(_delta: float) -> void:
	player.velocity.x += player.dash * player.get_direction()
	
	if Input.is_action_just_pressed("jump") and $DashTimer.get_time_left() <= 0.1:
		jump_queued = true


func _dash_timeout() -> void:
	_on_dash_end()


func _on_dash_end() -> void:
	if player.is_on_floor():
		if is_zero_approx(Input.get_axis("move_left", "move_right")):
			transition_requested.emit("idle", {"jump_queued": jump_queued})
		else:
			transition_requested.emit("run", {"jump_queued": jump_queued})
	else:
		transition_requested.emit("fall")


func _exit() -> void:
	jump_queued = false
	player.velocity.x = 0.0
	player.update_dash_cooldown(true)
	player.can_attack = true


func _on_hurt(_health, _max_health):
	$DashTimer.stop()
	_on_dash_end()
