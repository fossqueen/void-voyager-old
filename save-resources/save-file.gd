extends Reference
class_name SaveFile

const SAVE_FILE_PATH := "res://save.json"
export var version := 1

export var player: Resource = PlayerSave.new()
export var galaxy: Resource = Galaxy.new()

var _file := File.new()

func save_exists() -> bool:
	return _file.file_exists(SAVE_FILE_PATH)

func write_savefile() -> void:
	var error := _file.open(SAVE_FILE_PATH, File.WRITE)
	if error != OK:
		printerr("Could not open the file %s. Aborting save operation. Error code %s" % [SAVE_FILE_PATH, error])
		return
	
	var data := {
		"player":{
				"display_name": player.display_name,
				"credits": player.credits,
				"current_ship":{
					"name": player.current_ship.name,
					"health": player.current_ship.health,
					"shield": player.current_ship.shield,
					"fuel": player.current_ship.fuel,
				},
				"current_system": player.current_system,
				"inventory": player.inventory.items,
		},
		"galaxy": galaxy.galaxy,
	}
	
	var json_string := JSON.print(data)
	_file.store_string(json_string)
	_file.close()

func load_savefile() -> void:
	var error := _file.open(SAVE_FILE_PATH, File.READ)
	if error != OK:
		printerr("Could not open the file %s. Aborting load operation. Error code %s" % [SAVE_FILE_PATH, error])
		return
	
	var content := _file.get_as_text()
	_file.close()
	
	var data: Dictionary = JSON.parse(content).result
	if data == null:
		return
	
	player = PlayerSave.new()
	player.display_name = data.player.display_name
	player.credits = data.player.credits
	var current_ship = Ship.new()
	current_ship.name = data.player.current_ship.name
	current_ship.health = data.player.current_ship.health
	current_ship.shield = data.player.current_ship.shield
	current_ship.fuel = data.player.current_ship.fuel
	player.current_ship = current_ship
	player.current_system = data.player.current_system
	var inventory = Inventory.new()
	inventory.items = data.player.inventory
	player.inventory = inventory
	
	galaxy = Galaxy.new()
	galaxy.galaxy = data.galaxy
