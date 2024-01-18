class_name HUD
extends Control


func update_health_bar(value: float, instant := false) -> void:
	%PlayerStatus.update_health_bar(value, instant)


func update_mana_bar(value: float, instant := false) -> void:
	%PlayerStatus.update_mana_bar(value, instant)


func set_active_spell(id: int) -> void:
	%PlayerStatus.set_active_spell(id)
