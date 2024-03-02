extends Node2D


@export var max_x_difference := 64.0
@export var tilt := 0.07

@onready var model: Model = $PodModel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var movement_flag := false
var old_x: float
var direction: Constants.X_DIRECTION


func _ready() -> void:
	animation_player.play("default")


func _on_player_position_updated(pos: Vector2) -> void:
	if movement_flag:
		position.x -= abs(pos.x - old_x) * direction
		
		if -direction * position.x > max_x_difference:
			position.x = clampf(position.x, -max_x_difference, max_x_difference)
			movement_flag = false
	
	old_x = pos.x


func _on_player_direction_changed(_old_direction: Constants.X_DIRECTION, new_direction: Constants.X_DIRECTION) -> void:
	direction = new_direction
	set_rotation(tilt * direction)
	model.apply_direction(new_direction)
	movement_flag = true
