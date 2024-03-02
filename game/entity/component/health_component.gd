class_name HealthComponent
extends Area2D
## Component that manages health, taking damage and invincibility


signal on_hurt(current, max)
signal on_death()

@export var max_health := 10.0

@onready var health := max_health

var invincible := false


func hurt(amount: float) -> bool:
	if not invincible:
		health = max(0, health - amount)
		on_hurt.emit(health, max_health)
		
		if health == 0:
			death()
		
		return true
	else:
		return false


func death() -> void:
	on_death.emit()


func disable_hurtbox(flag) -> void:
	for child in find_children("*", "CollisionShape2D"):
		child.set_deferred("disabled", flag)
