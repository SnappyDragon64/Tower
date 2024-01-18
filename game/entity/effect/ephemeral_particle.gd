extends CPUParticles2D


func _ready() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timeout)
	timer.start(lifetime)


func _on_timeout() -> void:
	queue_free()
