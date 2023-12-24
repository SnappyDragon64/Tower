extends PlayerState


var jump_queued := false
var saved_velocity: Vector2


func _enter(_message = {}) -> void:
	saved_velocity = player.velocity
	player.velocity = Vector2.ZERO
	player.model.play_animation("attack")
	$AttackTimer.start()


func _state_physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and $AttackTimer.get_time_left() < 0.1:
		jump_queued = true


func _exit() -> void:
	player.velocity = saved_velocity


func _attack_timeout() -> void:
	if player.is_on_floor():
		if is_zero_approx(Input.get_axis("move_left", "move_right")):
			transition_requested.emit("idle", {"jump_queued": jump_queued})
		else:
			transition_requested.emit("run", {"jump_queued": jump_queued})
	else:
		transition_requested.emit("fall")
