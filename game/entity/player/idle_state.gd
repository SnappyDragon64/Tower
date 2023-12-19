extends PlayerState


func _enter(_msg = {}):
	player.model.play_animation("idle")


func _state_process(_delta: float) -> void:
	if not player.is_on_floor():
		transition_requested.emit("fall")
	elif not is_equal_approx(Input.get_axis("move_left", "move_right"), 0.0):
		transition_requested.emit("run")
	elif Input.is_action_just_pressed("jump"):
		transition_requested.emit("jump")
