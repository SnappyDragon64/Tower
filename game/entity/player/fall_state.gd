extends PlayerState


var jump_queued := false
var coyote := false


func _enter(_msg = {}) -> void:
	if player.jump_count == 0 and (state_machine.last_state == "idle" or state_machine.last_state == "run"):
		coyote = true
		$CoyoteTimer.start()
	
	player.jump_count += 1
	player.model.play_animation("jump")


func _state_physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		if coyote or player.jump_count < player.max_jumps:
			player.jump_count -= 1 if coyote else 0 # Current fall state effectively did not happen, so replenish a jump
			transition_requested.emit("jump")
		else:
			jump_queued = true
			$JumpQueueTimer.start()
	elif player.dash_count < player.max_dashes and Input.is_action_just_pressed("dash"):
		transition_requested.emit("dash")
	
	var run_input = Input.get_axis("move_left", "move_right")
	
	if player.is_on_floor():
		if jump_queued and Input.is_action_pressed("jump"):
			transition_requested.emit("jump")
		else:
			if is_equal_approx(run_input, 0.0):
				transition_requested.emit("idle")
			else:
				transition_requested.emit("run")
	
	player.velocity -= player.gravity * player.get_up_direction() * delta
	player.velocity.x = run_input * player.speed


func _jump_queue_timeout() -> void:
	jump_queued = false


func _coyote_timeout() -> void:
	coyote = false


func _exit() -> void:
	$JumpQueueTimer.stop()
	$CoyoteTimer.stop()
	jump_queued = false
	coyote = false
