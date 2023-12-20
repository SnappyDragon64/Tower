extends PlayerState


var jump_queued := false


func _enter(message = {}) -> void:
	player.jump_count = 0
	player.dash_count = 0
	player.model.play_animation("run")
	jump_queued = message.get("jump_queued", false)


func _state_physics_process(_delta: float) -> void:
	var run_input = Input.get_axis("move_left", "move_right")

	player.velocity.x = run_input * player.speed
	player.direction = sign(player.velocity.x) if not is_zero_approx(player.velocity.x) else player.direction
	player.model.apply_direction(player.direction)

	if jump_queued and Input.is_action_pressed("jump"):
		transition_requested.emit("jump")
	elif not player.is_on_floor():
		transition_requested.emit("fall")
	elif is_zero_approx(run_input):
		transition_requested.emit("idle")
	elif player.can_jump() and Input.is_action_just_pressed("jump"):
		transition_requested.emit("jump")
	elif player.can_dash() and Input.is_action_just_pressed("dash"):
		transition_requested.emit("dash")

func _exit() -> void:
	player.velocity.x = 0.0
