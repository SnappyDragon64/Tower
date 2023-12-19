class_name Model
extends Node2D


@export var animation_player: AnimationPlayer

@onready var initial_scale: Vector2 = Vector2.ONE

var direction = 1


# Initial setup
func _ready() -> void:
	initial_scale = get_scale()


# Flip the model according to the movement
func apply_direction(movement: float) -> void:
	direction = sign(movement) if not is_equal_approx(movement, 0) else direction
	scale.x = initial_scale.x * direction


# Play an animation
func play_animation(animation: String) -> void:
	animation_player.play(animation)
