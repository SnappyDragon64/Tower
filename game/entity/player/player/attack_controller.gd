extends Node


@export var damage := 10.0
@export var recoil := 1000.0

@onready var effect_kick_slash: Sprite2D

var player: Player
var valid_states := ["idle", "run", "jump", "fall"]
var recoil_flag := false


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null)
	
	effect_kick_slash = player.model.get_node("Effects/KickSlash")


func _physics_process(_delta) -> void:
	if player.movement_controller.current_state.state_id in valid_states and player.can_attack and not player.charging and Input.is_action_just_pressed("attack"):
		$AttackTimer.start()
		player.can_attack = false
		player.attacking = true
		effect_kick_slash.set_visible(true)
		player.play_animation("attack")
		player.animation_locked = true
	
	if player.attacking and is_equal_approx($AttackTimer.get_time_left(), 0.1):
		player.attack_controller.set_monitoring(true)


func _on_direction_changed(_old_direction, _new_direction) -> void:
	_cancel_attack()
	$AttackTimer.stop()


func _attack_timeout() -> void:
	_cancel_attack()


func _cancel_attack() -> void:
	recoil_flag = false
	player.attack_controller.set_monitoring(false)
	player.animation_locked = false
	player.attacking = false
	effect_kick_slash.set_visible(false) # in case of preliminary attack cancel
	var current_anim = player.movement_controller.current_state.animation
	player.play_animation(current_anim)
	$AttackCooldown.start()


func _attack_cooldown_timeout() -> void:
	player.can_attack = true


# When objects with physics collision are hit (i.e. terrain or props)
func _on_body_entered(_body: Node2D) -> void:
	_apply_recoil()


# When enemies are hit
func _on_area_entered(area: Area2D):
	_apply_recoil()
	
	if area is HealthComponent:
		area.hurt(damage)


# Checking recoil_flag prevents recoil from being applied more than once
func _apply_recoil() -> void:
	if not recoil_flag:
		player.velocity.x -= player.get_direction() * recoil
		recoil_flag = true
