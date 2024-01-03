class_name Player
extends DirectionalCharacterBody2D


signal position_updated(pos: Vector2)

@export var gravity := 1200.0
@export var speed := 360.0
@export var dash := 250.0
@export var jump := -960.0
@export var max_jumps := 1
@export var slide := 180.0
@export var terminal_velicity := 6000.0

@onready var model: Model = $PlayerModel
@onready var health_component: HealthComponent = $HealthComponent
@onready var movement_controller: StateMachine = $MovementController
@onready var hand_raycast_r: RayCast2D = $Raycasts/HandRaycastR
@onready var foot_raycast_r: RayCast2D = $Raycasts/FootRaycastR
@onready var hand_raycast_l: RayCast2D = $Raycasts/HandRaycastL
@onready var foot_raycast_l: RayCast2D = $Raycasts/FootRaycastL
@onready var attack_area: Area2D = $Areas/AttackArea
@onready var dash_cooldown_timer: Timer = $Timers/DashCooldownTimer
@onready var glitch_timer: Timer = $Timers/GlitchTimer
@onready var invincibility_timer: Timer = $Timers/InvincibilityTimer
@onready var invincibility_tween: Tween

var jump_count := 0
var dash_cooldown := false
var can_attack := true
var attacking := false
var animation_locked := false


func _ready():
	super._ready()
	
	health_component.on_hurt.connect(_on_hurt)
	health_component.on_death.connect(_on_death)

	update_hp_bar(health_component.health, health_component.max_health, true)


# physics_process
func _physics_process(_delta: float) -> void:
	velocity.y = min(terminal_velicity, velocity.y)
	move_and_slide()
	position_updated.emit(position)


func can_jump() -> bool:
	return jump_count < max_jumps


func can_dash() -> bool:
	return not attacking and not dash_cooldown


func set_direction(dir: Constants.DIRECTION) -> void:
	super.set_direction(dir)
	model.apply_direction(dir)
	attack_area.set_scale(Vector2(dir, 1))


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
	update_hp_bar(health, max_health)
	health_component.disable_hurtbox(true)
	start_invincibility()
	start_glitch()


func start_invincibility():
	health_component.invincible = true
	invincibility_timer.start()
	_invincibility_effect()


func _invincibility_effect():
	invincibility_tween = get_tree().create_tween()
	invincibility_tween.set_loops(4)
	invincibility_tween.tween_property(model.get_node("Parts/LowerBody/UpperBody/Head/HairFront"), "modulate", Color(0, 1, 1), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	invincibility_tween.tween_property(model.get_node("Parts/LowerBody/UpperBody/Head/HairFront"), "modulate", Color(1, 1, 1), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func start_glitch():
	glitch_timer.start()
	model.get_node("Effects/Glitch").set_visible(true)


func _on_death() -> void:
	if is_instance_valid(invincibility_tween):
		invincibility_tween.stop()
	
	WorldManager.respawn_player()


func update_hp_bar(health: float, max_health: float, instant := false):
	var hud: HUD = UIManager.get_hud()
	var value = health / max_health * 100.0
	hud.update_hp_bar(value, instant)


func _on_glitch_timer_timeout():
	model.get_node("Effects/Glitch").set_visible(false)


func _on_invincibility_timer_timeout():
	health_component.invincible = false
	health_component.disable_hurtbox(false)
