extends Node2D


@onready var health_progress: Polygon2D = $SpellHexagon/HealthBar/Under/Progress
@onready var mana_progress: Polygon2D = $SpellHexagon/ManaBar/Under/Progress
@onready var default_health_polygon: PackedVector2Array = health_progress.get_polygon()
@onready var default_mana_polygon: PackedVector2Array = mana_progress.get_polygon()
@onready var spell_slots: Array[Polygon2D] = [$SpellHexagon/Spells/Slot1/Icon, $SpellHexagon/Spells/Slot2/Icon, $SpellHexagon/Spells/Slot3/Icon, $SpellHexagon/Spells/Slot4/Icon]
@onready var active_spell: Polygon2D = $SpellHexagon/ActiveSpell
@onready var cooldown_overlay: Polygon2D = $SpellHexagon/ActiveSpell/Overlay

var health_tween: Tween
var mana_tween: Tween
var overlay_tween: Tween

var health: float:
	set(value):
		_update_progress(health_progress, default_health_polygon, value)
		health = value
	get:
		return health

var mana: float:
	set(value):
		_update_progress(mana_progress, default_mana_polygon, value)
		mana = value
	get:
		return mana


func update_health_bar(value: float, instant := false) -> void:
	_stop_tween(health_tween)
	
	if instant:
		health = value
	else:
		health_tween = _start_tween("health", value)


func update_mana_bar(value: float, instant := false) -> void:
	_stop_tween(mana_tween)
	
	if instant:
		mana = value
	else:
		mana_tween = _start_tween("mana", value)


func _update_progress(progress: Polygon2D, default_polygon: PackedVector2Array, value: float) -> void:
	var bottom_endpoint = default_polygon[0].lerp(default_polygon[3], value)
	var top_endpoint = default_polygon[1].lerp(default_polygon[2], value)
	var polygon = progress.get_polygon()
	polygon.set(2, top_endpoint)
	polygon.set(3, bottom_endpoint)
	progress.set_polygon(polygon)


func _start_tween(property: NodePath, value: float) -> Tween:
	var tween = get_tree().create_tween()
	tween.tween_property(self, property, value, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	return tween


func _stop_tween(tween: Tween) -> void:
	if is_instance_valid(tween):
		tween.stop()


func set_active_spell(id: int) -> void:
	for i in range(4):
		var current_slot = spell_slots[i]
		
		if i == id:
			current_slot.set_color(Color(1.0, 1.0, 1.0))
			var current_texture: Texture2D = current_slot.get_texture()
			active_spell.set_texture(current_texture)
		else:
			current_slot.set_color(Color(0.5, 0.5, 0.5))


func start_cooldown() -> void:
	cooldown_overlay.set_texture_offset(Vector2(0, 86))
	overlay_tween = get_tree().create_tween()
	overlay_tween.tween_property(cooldown_overlay, "texture_offset", Vector2(0, -31), 0.8)


func reset() -> void:
	_stop_tween(health_tween)
	_stop_tween(mana_tween)
	_stop_tween(overlay_tween)
