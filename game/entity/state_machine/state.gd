class_name State
extends Node


signal transition_requested(new_state_name: StringName, message: Dictionary)

@export var state_id: String
@onready var state_machine: StateMachine


# Called when the state is entered
func _enter(_message := {}) -> void:
	pass


# Called during process
func _state_process(_delta: float) -> void:
	pass


# Called during physics_process
func _state_physics_process(_delta: float) -> void:
	pass


# Called when the node is exited
func _exit() -> void:
	pass
