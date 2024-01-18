extends PlayerState


var jump_queued := false


func _enter(message = {}) -> void:
	player.jump_count = 0
	player.update_dash_cooldown(false)
	player.set_direction(-player.get_wall_direction())
	player.velocity.y = player.slide
	player.play_animation("slide")
	jump_queued = message.get("jump_queued", false)


func _state_physics_process(_delta: float) -> void:
	var run_input = sign(Input.get_axis("move_left", "move_right"))
	player.velocity.x = run_input * player.speed
	
	if jump_queued and Input.is_action_pressed("jump") or player.can_jump() and Input.is_action_just_pressed("jump"):
		transition_requested.emit("jump", {"wall": true})
	elif player.can_dash() and Input.is_action_just_pressed("dash"):
		transition_requested.emit("dash")
	elif player.is_on_floor():
		if is_zero_approx(run_input):
			transition_requested.emit("idle")
		else:
			transition_requested.emit("run")
	elif not player.on_wall():
		transition_requested.emit("fall")


func _exit() -> void:
	player.velocity.x = 0.0
