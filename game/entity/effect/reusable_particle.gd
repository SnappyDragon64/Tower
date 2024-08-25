extends CPUParticles2D

var timer: Timer
var tween: Tween


func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.set_one_shot(true)
	timer.timeout.connect(_kill)


func start() -> void:
	timer.stop()
	
	if is_instance_valid(tween):
		tween.kill()
	
	restart()
	set_visible(true)
	set_modulate(Color(1, 1, 1, 1))


func stop() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	timer.start(0.11)


func _kill() -> void:
	set_visible(false)
