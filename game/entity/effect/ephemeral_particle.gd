extends CPUParticles2D


func _ready() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timeout)
	timer.start(lifetime)


func _on_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_kill)
	timer.start(0.11)


func _kill() -> void:
	queue_free()
