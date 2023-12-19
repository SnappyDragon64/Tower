extends PlayerState


func _enter(_msg = {}):
	player.model.play_animation("jump")


func _state_process(delta: float) -> void:
	var run_input = Input.get_axis("move_left", "move_right")
	
	if player.is_on_floor():
		if is_equal_approx(run_input, 0):
			transition_requested.emit("idle")
		else:
			transition_requested.emit("run")
	
	
	player.apply_gravity(delta)
	player.model.apply_direction(run_input)
	player.velocity.x = run_input * player.speed
