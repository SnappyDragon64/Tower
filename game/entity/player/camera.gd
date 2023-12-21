class_name Camera
extends Camera2D


var x_min := -10000.0
var x_max := 10000.0
var y_min := -10000.0
var y_max := 10000.0

var tracking_player := true
var update_flag := false
var target := Vector2(0, 0)


func _ready() -> void:
	if is_instance_valid(WorldManager.get_player()):
		WorldManager.get_player().position_updated.connect(_on_player_position_updated)


func lock_camera(start: Vector2, end: Vector2) -> void:
	x_min = min(start.x, end.x)
	y_min = min(start.y, end.y)
	x_max = max(start.x, end.x)
	y_max = max(start.y, end.y)


func update_zoom(zoom_vector := Vector2.ONE) -> void:
	set_zoom(zoom_vector)


func track_player(flag := true) -> void:
	tracking_player = flag


func set_target(target_position: Vector2, disable_player_tracking := true) -> void:
	track_player(not disable_player_tracking)
	target = target_position
	update_flag = true


func _physics_process(_delta: float) -> void:
	if update_flag:
		var origin_clamped = _get_adjusted_tracking_pos()
		var transform_clamped = Transform2D(0, origin_clamped)
		set_global_transform(transform_clamped)
		update_flag = false


func _on_player_position_updated(new_position: Vector2) -> void:
	if tracking_player:
		set_target(new_position, false)


func _get_adjusted_tracking_pos() -> Vector2:
	var x_clamped = clamp(target.x, x_min, x_max)
	var y_clamped = clamp(target.y, y_min, y_max)
	var origin_clamped = Vector2(x_clamped, y_clamped)
	return origin_clamped
