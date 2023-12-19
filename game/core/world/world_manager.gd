extends Node
## An interface to the level loader

var _world: World = null
var _current_level: PackedScene = null
var _current_spawnpoint := 0


# Sets up the level loader
func create() -> void:
	_world = World.new()
	get_tree().get_root().add_child(_world)


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
func reload_level():
	_load_current_level()


# Loads the current level
func _load_current_level():
	_world._load_level(_current_level)
	spawn_player()


# Updates the players spawnpoint
func update_spawnpoint(spawnpoint: int) -> void:
	_current_spawnpoint = spawnpoint


# Spawns the player at the specified spawnpoint
func spawn_player(spawnpoint := _current_spawnpoint) -> void:
	_world.spawn_player(spawnpoint)
