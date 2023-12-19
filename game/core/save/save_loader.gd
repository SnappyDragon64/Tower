extends Node
## Used for managing saves according to slots


var current_slot := 0


# Loads a save from the specified slot
func load_save_from_slot(save_slot: int) -> void:
	_set_slot(save_slot)
	load_data()


# Loads the save data for the current slot
func load_data() -> void:
	if not FileAccess.file_exists(_get_save_path()):
		SaveData.current_save = SaveData.DEFAULT
		save_data()
	else:
		var save := FileAccess.open(_get_save_path(), FileAccess.READ)
		var json_string := save.get_line()
		var parsed_json: Dictionary = JSON.parse_string(json_string)
		_fill_missing_values(parsed_json)
		SaveData.current_save = parsed_json
		save.close()


# Saves the save data to the current slot
func save_data() -> void:
	var save := FileAccess.open(_get_save_path(), FileAccess.WRITE)
	var json_string := JSON.stringify(SaveData.current_save)
	save.store_line(json_string)
	save.close()


# Erases the save data from the specified slot
func delete_data(save_slot: int) -> void:
	var dir = DirAccess.open("user://")
	dir.remove(_get_save_path(save_slot))


# Sets the current save slot
func _set_slot(save_slot: int) -> void:
	current_slot = save_slot


# Gets the save path
func _get_save_path(save_slot: int = current_slot) -> String:
	var save_path := "user://save%s.dat" % save_slot
	return save_path


# Fills missing values in loaded saves
func _fill_missing_values(dict: Dictionary) -> void:
	for key in SaveData.DEFAULT.keys():
		if not dict.has(key):
			dict[key] = SaveData.DEFAULT[key]
