extends Node2D


@onready var TITLE_MENU: PackedScene = preload(Menus.TITLE_MENU)


# Inital settngs
func _ready() -> void:
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Instantiate the title menu and destroy this scene
func _process(_delta) -> void:
	var title_menu_instance = TITLE_MENU.instantiate()
	get_tree().get_root().add_child(title_menu_instance)
	queue_free()
