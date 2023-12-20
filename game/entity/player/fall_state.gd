extends PlayerState

var grounded_states = ["idle", "run", "slide"]
var jump_queued := false
var coyote := false
var wall := false


func _enter(_message = {}) -> void:
	if player.jump_count == 0 and state_machine.last_state in grounded_states:
		wall = state_machine.last_state == "slide"
		coyote = true
		$CoyoteTimer.start()
	
	player.jump_count += 1
	player.model.play_animation("jump")


func _state_physics_process(delta: float) -> void:
	var run_input = Input.get_axis("move_left", "move_right")
	
	player.velocity -= player.gravity * player.get_up_direction() * delta
	player.velocity.x = run_input * player.speed
	player.direction = sign(player.velocity.x) if not is_zero_approx(player.velocity.x) else player.direction
	player.model.apply_direction(player.direction)
	
	if Input.is_action_just_pressed("jump"):
		if coyote or player.can_jump():
			player.jump_count -= 1 if coyote else 0 # Current fall state effectively did not happen, so replenish a jump
			transition_requested.emit("jump", {"wall": wall})
		else:
			jump_queued = true
			$JumpQueueTimer.start()
	elif player.can_dash() and Input.is_action_just_pressed("dash"):
		transition_requested.emit("dash")
	
	if player.is_on_floor():
		if is_zero_approx(run_input):
			transition_requested.emit("idle", {"jump_queued": jump_queued})
		else:
			transition_requested.emit("run", {"jump_queued": jump_queued})
	elif player.is_on_wall():
		transition_requested.emit("slide", {"jump_queued": jump_queued})


func _jump_queue_timeout() -> void:
	jump_queued = false


func _coyote_timeout() -> void:
	coyote = false


func _exit() -> void:
	player.velocity.x = 0.0
	
	$JumpQueueTimer.stop()
	$CoyoteTimer.stop()
	jump_queued = false
	coyote = false
