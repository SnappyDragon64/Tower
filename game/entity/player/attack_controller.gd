extends Node


@export var damage := 10
@export var recoil := 1000

var player: Player
var valid_states := ["idle", "run", "jump", "fall"]
var recoil_flag := false


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null)
	player.direction_changed.connect(_on_direction_changed)


func _physics_process(_delta) -> void:
	if player.movement_controller.current_state.state_id in valid_states and player.can_attack and Input.is_action_just_pressed("attack"):
		$AttackTimer.start()
		player.can_attack = false
		player.attacking = true
		player.model.get_node("Effects/KickSlash").set_visible(true)
		player.play_animation("attack")
		player.animation_locked = true
	
	if player.attacking and is_equal_approx($AttackTimer.get_time_left(), 0.1):
		player.attack_area.set_monitoring(true)


func _on_direction_changed(_old_direction, _new_direction) -> void:
	_cancel_attack()
	$AttackTimer.stop()


func _attack_timeout() -> void:
	_cancel_attack()


func _cancel_attack() -> void:
	recoil_flag = false
	player.attack_area.set_monitoring(false)
	player.animation_locked = false
	player.attacking = false
	player.model.get_node("Effects/KickSlash").set_visible(false) # in case of preliminary attack cancel
	var current_anim = player.movement_controller.current_state.animation
	player.play_animation(current_anim)
	$AttackCooldown.start()


func _attack_cooldown_timeout() -> void:
	player.can_attack = true


func _on_attack_area_body_entered(body: Node2D) -> void:
	if not recoil_flag:
		player.velocity.x = -player.direction * recoil
		recoil_flag = true
	
	if body.is_in_group("enemy"):
		var health_component: HealthComponent = body.find_children("*", "HealthComponent").front()
		if is_instance_valid(health_component):
			health_component.hurt(damage)
