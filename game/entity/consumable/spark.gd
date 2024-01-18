class_name Spark
extends CharacterBody2D


@export var gravity := 1000.0
@export var speed := 800.0
@export var dampening := 200.0

var free := true
var can_be_picked_up := false


func _physics_process(delta) -> void:	
	if free:
		if is_on_floor():
			velocity.x = 0.0
			speed = 0.0
		
		velocity.y += gravity * delta
		velocity.x += speed * delta
		speed = move_toward(speed, 0.0, dampening)
	
	move_and_slide()


func _on_pickup_delay_timeout() -> void:
	can_be_picked_up = true


func _on_lifetime_timeout():
	queue_free()
