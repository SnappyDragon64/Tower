class_name World
extends Node2D
## The level loader that has a reference to the active player and level


@onready var player_preload = preload('res://game/entity/player/player.tscn')
@onready var camera_preload = preload('res://game/entity/player/camera.tscn')


var player: Player
var camera: Camera
var active_level: Node2D


# Loads level from the PackedScene
func _load_level(level: PackedScene) -> void:
	for entity in $SpawnedEntities.get_children():
		entity.queue_free()
	
	for inactive_level in $LevelHolder.get_children():
		inactive_level.queue_free()
	
	active_level = level.instantiate()
	$LevelHolder.call_deferred("add_child", active_level)
	await active_level.ready


# Spawns an entity at the specified position
func spawn(entity: Variant, spawn_at := Vector2()) -> void:
	entity.set_position(spawn_at)
	$SpawnedEntities.call_deferred("add_child", entity)


# Spawns player at the specified spawnpoint
func spawn_player(spawnpoint := 0) -> Player:
	_purge()
	
	player = player_preload.instantiate()
	camera = camera_preload.instantiate()
	var pos = Vector2()
	var cam_pos = Vector2()
	
	var spawnpoints = active_level.get_node_or_null("Spawnpoints")
	if spawnpoints != null and spawnpoint >= 0 and spawnpoint < spawnpoints.get_child_count():
		var spawnpoint_node = spawnpoints.get_child(spawnpoint)
		pos = spawnpoint_node.get_global_transform().get_origin()
		
		var camera_spawnpoint = spawnpoint_node.get_node_or_null("Camera")
		if camera_spawnpoint != null:
			cam_pos = camera_spawnpoint.get_global_transform().get_origin()
		else:
			cam_pos = pos
	
	spawn(player, pos)
	spawn(camera, cam_pos)
	
	return player


func _purge() -> void:
	if is_instance_valid(player):
		player.queue_free()
	if is_instance_valid(camera):
		camera.queue_free()
	
