extends PlayerState


var jump_queued := false


func _enter(message = {}) -> void:
	player.jump_count = 0
	player.dash_count = 0
	player.model.play_animation("idle")
	jump_queued = message.get("jump_queued", false)


func _state_physics_process(_delta: float) -> void:
	if jump_queued and Input.is_action_pressed("jump"):
		transition_requested.emit("jump")
	elif not player.is_on_floor():
		transition_requested.emit("fall")
	elif not is_zero_approx(Input.get_axis("move_left", "move_right")):
		transition_requested.emit("run")
	elif player.can_jump() and Input.is_action_just_pressed("jump"):
		transition_requested.emit("jump")
	elif player.can_dash() and Input.is_action_just_pressed("dash"):
		transition_requested.emit("dash")
