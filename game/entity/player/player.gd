class_name Player
extends CharacterBody2D


signal position_updated(pos: Vector2)
signal direction_changed(old_direction: int, new_direction: int)

@export var gravity := 1200.0
@export var speed := 360.0
@export var dash := 250.0
@export var jump := -960.0
@export var max_jumps := 1
@export var slide := 180

@onready var model: Model = $PlayerModel
@onready var movement_controller: StateMachine = $MovementController
@onready var hand_raycast_r: RayCast2D = $Raycasts/HandRaycastR
@onready var foot_raycast_r: RayCast2D = $Raycasts/FootRaycastR
@onready var hand_raycast_l: RayCast2D = $Raycasts/HandRaycastL
@onready var foot_raycast_l: RayCast2D = $Raycasts/FootRaycastL
@onready var attack_area: Area2D = $Areas/AttackArea
@onready var dash_cooldown_timer: Timer = $Timers/DashCooldownTimer

var direction := 1
var jump_count := 0
var dash_cooldown := false
var can_attack := true
var attacking := false
var animation_locked := false


# physics_process
func _physics_process(_delta: float) -> void:
	move_and_slide()
	position_updated.emit(position)


func can_jump() -> bool:
	return jump_count < max_jumps


func can_dash() -> bool:
	return not attacking and not dash_cooldown


func set_direction(dir: int) -> void:
	if not direction == dir:
		direction_changed.emit(direction, dir)
	
	direction = dir
	model.apply_direction(dir)
	attack_area.set_scale(Vector2(direction, 1))


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
