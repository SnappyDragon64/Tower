class_name DirectionalCharacterBody2D
extends CharacterBody2D


signal direction_changed(old_direction: Constants.X_DIRECTION, new_direction: Constants.X_DIRECTION)

@export var direction: Constants.X_DIRECTION = Constants.X_DIRECTION.RIGHT


# Must call when overriden
func _ready() -> void:
	set_direction(direction)


func get_direction() -> Constants.X_DIRECTION:
	return direction


# Must call when overriden
func set_direction(raw_direction: Constants.X_DIRECTION) -> void:
	if not is_zero_approx(raw_direction):
		var old_direction = direction
		direction = Constants.X_DIRECTION.LEFT if raw_direction < 0 else Constants.X_DIRECTION.RIGHT
		
		if not old_direction == direction:
			direction_changed.emit(old_direction, direction)
