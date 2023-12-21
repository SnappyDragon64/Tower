class_name Player
extends CharacterBody2D


@export var gravity := 1200.0
@export var speed := 360.0
@export var dash := 250.0
@export var jump := -960.0
@export var max_jumps := 1
@export var max_dashes := 1
@export var slide := 160

@onready var model: Model = $PlayerModel
@onready var hand_raycast_r: RayCast2D = $Raycasts/HandRaycastR
@onready var foot_raycast_r: RayCast2D = $Raycasts/FootRaycastR
@onready var hand_raycast_l: RayCast2D = $Raycasts/HandRaycastL
@onready var foot_raycast_l: RayCast2D = $Raycasts/FootRaycastL

var direction := 1
var jump_count = 0
var dash_count = 0
var dash_cooldown = false


# physics_process
func _physics_process(_delta: float) -> void:
	move_and_slide()


func can_jump() -> bool:
	return jump_count < max_jumps


func can_dash() -> bool:
	return not dash_cooldown and dash_count < max_dashes


func set_direction(dir: int) -> void:
	direction = dir
	model.apply_direction(dir)


func on_wall() -> bool:
	return hand_raycast_r.is_colliding() and foot_raycast_r.is_colliding() or hand_raycast_l.is_colliding() and foot_raycast_l.is_colliding()


func get_wall_direction() -> int:
	return 1 if hand_raycast_r.is_colliding() and foot_raycast_r.is_colliding() else -1 if hand_raycast_l.is_colliding() and foot_raycast_l.is_colliding() else 0
