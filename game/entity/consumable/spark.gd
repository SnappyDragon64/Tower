extends CharacterBody2D


@export var gravity := 200.0
@export var speed := 400.0
@export var dampening := 200.0

var freeze := false
var can_be_picked_up := false


func _physics_process(delta) -> void:
	if not freeze and is_on_floor():
		freeze = true
		velocity = Vector2.ZERO
	
	if not freeze:
		velocity.y += gravity * delta
		velocity.x += speed * delta
		speed = move_toward(speed, 0.0, dampening)
	
	move_and_slide()


func _on_pickup_delay_timeout() -> void:
	can_be_picked_up = true


func _on_lifetime_timeout():
	queue_free()
