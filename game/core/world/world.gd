class_name World
extends Node2D
## The level loader that has a reference to the active player and level


var player: Player = null
var active_level: Node2D = null


# Loads level from the PackedScene
func _load_level(level: PackedScene) -> void:
	for entity in $SpawnedEntities.get_children():
		entity.queue_free()
	
	for inactive_level in $LevelHolder.get_children():
		inactive_level.queue_free()
	
	active_level = level.instantiate()
	$LevelHolder.add_child(active_level)
	await active_level.ready


# Spawns an entity at the specified position
func spawn(entity: Variant, spawn_at := Vector2()) -> void:
	entity.set_position(spawn_at)
	$SpawnedEntities.add_child(entity)


# Spawns player at the specified spawnpoint
func spawn_player(spawnpoint := 0) -> void:
	player = Player.new()
	var pos = Vector2()
	
	var spawnpoints = active_level.get_node_or_null("Spawnpoints")
	if spawnpoints != null and spawnpoint >= 0 and spawnpoint < spawnpoints.get_child_count():
		var spawnpoint_node = spawnpoints.get_child(spawnpoint)
		pos = spawnpoint_node.get_global_transform().get_origin()
	
	spawn(player, pos)
