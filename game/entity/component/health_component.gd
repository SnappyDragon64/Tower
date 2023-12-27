## Component that manages health, taking damage and invincibility frames
class_name HealthComponent
extends Node


signal on_hurt()
signal on_death()

@export var health: int = 10


func hurt(amount: int) -> void:
	on_hurt.emit()
	health -= amount
	
	if health <= 0:
		death()


func death() -> void:
	on_death.emit()
	get_parent().queue_free()
