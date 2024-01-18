class_name PlayerState
extends State


@export var animation: String

var player: Player


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null)
