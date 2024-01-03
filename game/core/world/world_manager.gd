extends Node
## An interface to the level loader


@onready var world_preload = preload("res://game/core/world/world.tscn")

var _world: World = null
var _current_level: PackedScene = null
var _current_spawnpoint := 0


# Sets up the level loader
func create() -> void:
	for child in get_children():
		child.queue_free()
	
	_world = world_preload.instantiate()
	add_child(_world)


# Gets a reference to the player
func get_player() -> Player:
	return _world.player if is_instance_valid(_world) else null


# Loads a level according to the given id
func load_level(level: String, spawnpoint := 0) -> void:
	if is_instance_valid(_world):
		_current_level = load(level)
		_current_spawnpoint = spawnpoint
		_load_current_level()


# Reloads the current level
func reload_level() -> void:
	_load_current_level()


# Loads the current level
func _load_current_level() -> void:
	_world._load_level(_current_level)
	spawn_player()


# Updates the players spawnpoint
func update_spawnpoint(spawnpoint: int) -> void:
	_current_spawnpoint = spawnpoint


# Spawns the player at the specified spawnpoint
func spawn_player(spawnpoint := _current_spawnpoint) -> void:
	_world.spawn_player(spawnpoint)


# Repawns the player at the specified spawnpoint
func respawn_player(spawnpoint := _current_spawnpoint) -> void:
	var player = _world.spawn_player(spawnpoint)
	await player.ready
	player.start_invincibility()


# Spawns an entity at the specified position
func spawn(entity: Variant, spawn_at := Vector2()) -> void:
	_world.spawn(entity, spawn_at)
