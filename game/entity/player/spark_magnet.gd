extends Area2D


@export var pull := 400.0

# TEMP
@export var max_mana := 100.0
var mana := 0.0


func _ready() -> void:
	get_parent().get_parent().update_mana_bar(mana, max_mana)


func _physics_process(_delta) -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("spark"):
			body.freeze = true
			var diff = get_global_position() - body.position
			body.velocity = diff.normalized() * pull
			
			var player = get_parent().get_parent()
			if diff.length_squared() < 100.0 and mana < max_mana:
				mana += 10.0
				mana = min(mana, max_mana)
				player.update_mana_bar(mana, max_mana)
				body.queue_free()
