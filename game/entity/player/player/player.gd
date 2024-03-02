class_name Player
extends DirectionalCharacterBody2D


signal position_updated(pos: Vector2)

@export var speed := 360.0
@export var dash := 250.0
@export var jump := -1200.0
@export var max_jumps := 1
@export var slide := 180.0
@export var terminal_velocity := 10000.0

@onready var model: Model = $PlayerModel
@onready var health_component: HealthComponent = $HealthComponent
@onready var movement_controller: StateMachine = $MovementController
@onready var attack_controller: Area2D = $AttackController
@onready var hand_raycast_r: RayCast2D = $Raycasts/HandRaycastR
@onready var foot_raycast_r: RayCast2D = $Raycasts/FootRaycastR
@onready var hand_raycast_l: RayCast2D = $Raycasts/HandRaycastL
@onready var foot_raycast_l: RayCast2D = $Raycasts/FootRaycastL
@onready var dash_cooldown_timer: Timer = $Timers/DashCooldownTimer
@onready var glitch_timer: Timer = $Timers/GlitchTimer
@onready var invincibility_timer: Timer = $Timers/InvincibilityTimer
@onready var invincibility_tween: Tween

var jump_count := 0
var dash_cooldown := false
var can_attack := true
var attacking := false
var animation_locked := false


func _ready() -> void:
	super._ready()
	update_health_bar(health_component.health, health_component.max_health, true)


func _physics_process(_delta: float) -> void:
	velocity.y = min(terminal_velocity, velocity.y)
	move_and_slide()
	position_updated.emit(position)


func can_jump() -> bool:
	return jump_count < max_jumps


func can_dash() -> bool:
	return not attacking and not dash_cooldown


func set_direction(dir: Constants.X_DIRECTION) -> void:
	super.set_direction(dir)
	model.apply_direction(get_direction())
	attack_controller.set_scale(Vector2(get_direction(), 1))


func on_wall() -> bool:
	return hand_raycast_r.is_colliding() and foot_raycast_r.is_colliding() or hand_raycast_l.is_colliding() and foot_raycast_l.is_colliding()


func get_wall_direction() -> int:
	return 1 if hand_raycast_r.is_colliding() and foot_raycast_r.is_colliding() else -1 if hand_raycast_l.is_colliding() and foot_raycast_l.is_colliding() else 0


func update_dash_cooldown(flag: bool) -> void:
	dash_cooldown = flag
	dash_cooldown_timer.start() if flag else dash_cooldown_timer.stop()


func play_animation(animation: String) -> bool:
	if animation_locked:
		return false
	else:
		model.play_animation(animation)
		return true


func _dash_cooldown_timeout() -> void:
	dash_cooldown = false


func _on_hurt(health, max_health) -> void:
	update_health_bar(health, max_health)
	health_component.disable_hurtbox(true)
	start_invincibility()
	start_glitch()


func start_invincibility() -> void:
	health_component.invincible = true
	invincibility_timer.start()
	_invincibility_effect()


func _invincibility_effect() -> void:
	invincibility_tween = get_tree().create_tween()
	invincibility_tween.set_loops(4)
	invincibility_tween.tween_property(model.get_node("Parts/LowerBody/UpperBody/Head/HairFront"), "modulate", Color(0, 1, 1), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	invincibility_tween.tween_property(model.get_node("Parts/LowerBody/UpperBody/Head/HairFront"), "modulate", Color(1, 1, 1), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func start_glitch() -> void:
	glitch_timer.start()
	model.get_node("Effects/Glitch").set_visible(true)


func _on_death() -> void:
	if is_instance_valid(invincibility_tween):
		invincibility_tween.stop()
	
	WorldManager.respawn_player()
	UIManager.get_hud().reset()


func update_health_bar(health: float, max_health: float, instant := false) -> void:
	var hud := UIManager.get_hud()
	var value = health / max_health
	hud.update_health_bar(value, instant)


func update_mana_bar(mana: float, max_mana: float, instant := false) -> void:
	var hud := UIManager.get_hud()
	var value = mana / max_mana
	hud.update_mana_bar(value, instant)


func _on_glitch_timer_timeout() -> void:
	model.get_node("Effects/Glitch").set_visible(false)


func _on_invincibility_timer_timeout() -> void:
	health_component.invincible = false
	health_component.disable_hurtbox(false)
