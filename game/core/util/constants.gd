extends Node

var GRAVITY: float = ProjectSettings.get_setting("physics/2d/default_gravity")

const HALF_PI := PI / 2.0

enum X_DIRECTION {
	LEFT = -1,
	RIGHT = 1
}

enum Y_DIRECTION {
	UP = -1,
	DOWN = 1
}
