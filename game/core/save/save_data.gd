extends Node
## Used for accessing the currently loaded save data

const DEFAULT := {}

var current_save := {}

# Write a field to the current save file
func write(key: String, value: Variant) -> Variant:
	current_save[key] = value
	return value


# Read a field from the current save file
func read(key: String, default: Variant = null) -> Variant:
	return current_save.get(key, default)
