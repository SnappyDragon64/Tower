extends Control


func _on_button_pressed():
	WorldManager.create()
	WorldManager.load_level("res://game/level/debug.tscn")
	UIManager.load_hud()
	queue_free()
