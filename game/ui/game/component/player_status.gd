extends Node2D


@onready var health_progress: Polygon2D = $SpellHexagon/HealthBar/Progress
@onready var mana_progress: Polygon2D = $SpellHexagon/ManaBar/Progress
@onready var default_health_polygon: PackedVector2Array = health_progress.get_polygon()
@onready var default_mana_polygon: PackedVector2Array = mana_progress.get_polygon()

var health_tween: Tween
var mana_tween: Tween

var health: float:
	set(value):
		update_progress(health_progress, default_health_polygon, value)
		health = value
	get:
		return health

var mana: float:
	set(value):
		update_progress(mana_progress, default_mana_polygon, value)
		mana = value
	get:
		return mana


func update_health_bar(value: float, instant := false) -> void:
	if is_instance_valid(health_tween):
		health_tween.stop()
	
	if instant:
		health = value
	else:
		health_tween = get_tree().create_tween()
		health_tween.tween_property(self, "health", value, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func update_mana_bar(value: float, instant := false) -> void:
	if is_instance_valid(mana_tween):
		mana_tween.stop()
	
	if instant:
		mana = value
	else:
		mana_tween = get_tree().create_tween()
		mana_tween.tween_property(self, "mana", value, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func update_progress(progress: Polygon2D, default_polygon: PackedVector2Array, value: float) -> void:
	var bottom_endpoint = default_polygon[0].lerp(default_polygon[3], value)
	var top_endpoint = default_polygon[1].lerp(default_polygon[2], value)
	var polygon = progress.get_polygon()
	polygon.set(2, top_endpoint)
	polygon.set(3, bottom_endpoint)
	progress.set_polygon(polygon)

