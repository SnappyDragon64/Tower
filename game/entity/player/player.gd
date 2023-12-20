class_name Player
extends CharacterBody2D


@export var gravity := 600.0
@export var speed := 300.0
@export var dash := 200.0
@export var jump := -600.0
@export var max_jumps := 1
@export var max_dashes := 1
@export var slide := 200

@onready var model: Model = $PlayerModel

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
