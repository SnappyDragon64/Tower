class_name Player
extends CharacterBody2D


@export var gravity: float = 600
@export var speed: float = 300
@export var jump: float = -600

@onready var model: Model = $PlayerModel

var direction = 1


# physics_process
func _physics_process(_delta: float) -> void:
	move_and_slide()


# Apply gravity to the player, called by states that have gravity
func apply_gravity(delta: float) -> void:
	velocity -= gravity * get_up_direction() * delta
