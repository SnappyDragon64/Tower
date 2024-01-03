class_name HUD
extends Control


@onready var hp_bar: TextureProgressBar = %HPBar
@onready var mp_bar: TextureProgressBar = %MPBar

var hp_tween: Tween
var mp_tween: Tween


func update_hp_bar(value: float, instant := false) -> void:
	if is_instance_valid(hp_tween):
		hp_tween.stop()
	
	hp_tween = _update_range(hp_bar, value, instant)


func update_mp_bar(value: float, instant := false) -> void:
	if is_instance_valid(mp_tween):
		mp_tween.stop()

	mp_tween = _update_range(mp_bar, value, instant)


func _update_range(range_instance: Range, value: float, instant: bool) -> Tween:
	if instant:
		range_instance.set_value(value)
		return null
	else:
		return _tween_range_value(range_instance, value)


func _tween_range_value(range_instance: Range, value: float) -> Tween:
	var tween = get_tree().create_tween()
	tween.tween_property(range_instance, "value", value, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	return tween
