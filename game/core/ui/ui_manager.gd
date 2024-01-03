extends CanvasLayer


@onready var hud_preload: PackedScene = preload("res://game/ui/game/hud.tscn")

var hud: HUD


func load_hud() -> void:
	hud = hud_preload.instantiate()
	add_child(hud)


func clear_hud() -> void:
	hud.queue_free()


func get_hud() -> HUD:
	return hud
