extends PlayerState


var wall := false
var post_wall_jump_move := false


func _enter(message := {}) -> void:
	player.model.play_animation("jump")
	wall = message.get("wall", false)
	
	if wall:
		player.velocity.x = player.jump * 0.3 * -player.direction
		post_wall_jump_move = false
		$PostWallJumpMoveTimer.start()
	
	player.velocity.y = player.jump


func _state_physics_process(delta: float) -> void:
	var run_input = sign(Input.get_axis("move_left", "move_right"))
	player.velocity -= player.gravity * player.get_up_direction() * delta
	
	if !wall or post_wall_jump_move and not is_zero_approx(run_input):
		player.velocity.x = run_input * player.speed
	player.set_direction(sign(player.velocity.x) if not is_zero_approx(player.velocity.x) else player.direction)
	player.model.apply_direction(player.direction)
	
	if Input.is_action_just_pressed("attack"):
		transition_requested.emit("attack")
	elif player.velocity.y >= 0.0 or Input.is_action_just_released("jump"):
		transition_requested.emit("fall")
	elif player.can_dash() and Input.is_action_just_pressed("dash"):
		transition_requested.emit("dash")


func _exit() -> void:
	player.velocity.y = 0.0
	$PostWallJumpMoveTimer.stop()


func _post_wall_jump_move_timeout():
	post_wall_jump_move = true
