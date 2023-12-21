extends PlayerState


var jump_queued := false


func _enter(_message = {}) -> void:
	player.dash_count += 1
	player.model.play_animation("dash")
	$DashTimer.start()


func _state_physics_process(_delta: float) -> void:
	player.velocity.x += player.dash * player.direction
	
	if Input.is_action_just_pressed("jump") and $DashTimer.get_time_left() < 0.1:
		jump_queued = true


func _dash_timeout() -> void:
	if player.is_on_floor():
		if is_zero_approx(Input.get_axis("move_left", "move_right")):
			transition_requested.emit("idle", {"jump_queued": jump_queued})
		else:
			transition_requested.emit("run", {"jump_queued": jump_queued})
	else:
		transition_requested.emit("fall")


func _cooldown_timeout():
	player.dash_cooldown = false


func _exit() -> void:
	jump_queued = false
	player.velocity.x = 0.0
	player.dash_cooldown = true
	$CooldownTimer.start()
