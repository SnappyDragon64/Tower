extends PlayerState


func _enter(_msg = {}):
	player.model.play_animation("run")


func _state_physics_process(delta: float) -> void:
	var run_input = Input.get_axis("move_left", "move_right")
	
	if not player.is_on_floor():
		transition_requested.emit("fall")
	elif is_equal_approx(run_input, 0.0):
		transition_requested.emit("idle")
	elif Input.is_action_just_pressed("jump"):
		transition_requested.emit("jump")
	
	player.apply_gravity(delta)
	player.model.apply_direction(run_input)
	player.velocity.x = run_input * player.speed


func _exit() -> void:
	player.velocity.x = 0.0
