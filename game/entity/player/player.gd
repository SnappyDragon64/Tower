class_name Player
extends CharacterBody2D


@export var gravity := 600.0
@export var speed := 300.0
@export var jump := -600.0
@export var dash := 200.0

@onready var model: Model = $PlayerModel

var direction := 1
var can_dash := true

# physics_process
func _physics_process(_delta: float) -> void:
	direction = sign(velocity.x) if not is_equal_approx(velocity.x, 0) else direction
	model.apply_direction(direction)
	
	move_and_slide()
