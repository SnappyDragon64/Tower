extends PlayerState


func _enter(_msg = {}) -> void:
	player.can_dash = false
	player.model.play_animation("dash")
	$Timer.start()


func _state_physics_process(delta: float) -> void:
	player.velocity.x += player.dash * player.direction


func _dash_timeout() -> void:
	if player.is_on_floor():
		if is_equal_approx(Input.get_axis("move_left", "move_right"), 0.0):
			transition_requested.emit("idle")
		else:
			transition_requested.emit("run")
	else:
		transition_requested.emit("fall")


func _exit() -> void:
	player.velocity.x = 0.0
