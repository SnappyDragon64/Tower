extends PlayerState


func _enter(_msg = {}) -> void:
	player.jump_count = 0
	player.dash_count = 0
	player.model.play_animation("idle")


func _state_physics_process(_delta: float) -> void:
	if not player.is_on_floor():
		transition_requested.emit("fall")
	elif not is_equal_approx(Input.get_axis("move_left", "move_right"), 0.0):
		transition_requested.emit("run")
	elif player.can_jump() and Input.is_action_just_pressed("jump"):
		transition_requested.emit("jump")
	elif player.can_dash() and Input.is_action_just_pressed("dash"):
		transition_requested.emit("dash")
