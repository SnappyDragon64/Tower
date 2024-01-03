class_name DirectionalCharacterBody2D
extends CharacterBody2D


signal direction_changed(old_direction: Constants.DIRECTION, new_direction: Constants.DIRECTION)

@export var direction: Constants.DIRECTION = Constants.DIRECTION.RIGHT


# Must call when overriden
func _ready() -> void:
	set_direction(direction)


# Must call when overriden
func set_direction(dir: Constants.DIRECTION) -> void:
	if not direction == dir:
		direction_changed.emit(direction, dir)
	
	direction = dir
