extends PlayerState


func _enter(_message := {}) -> void:
	player.model.play_animation("jump")
	player.velocity.y += player.jump


func _state_physics_process(delta: float) -> void:
	if player.velocity.y >= 0.0 or Input.is_action_just_released("jump"):
		transition_requested.emit("fall")
	elif player.can_dash and Input.is_action_just_pressed("dash"):
		transition_requested.emit("dash")
	
	var run_input = Input.get_axis("move_left", "move_right")
	player.velocity -= player.gravity * player.get_up_direction() * delta
	player.velocity.x = run_input * player.speed


func _exit() -> void:
	player.velocity.y = 0.0
