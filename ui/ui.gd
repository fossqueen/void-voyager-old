extends CanvasLayer

onready var system_map_scene = load("res://ui/system-map/system-map.tscn")
onready var galaxy_map_scene = load("res://ui/galaxy-map/galaxy-map.tscn")

onready var radar = $Radar
onready var player_stats = $PlayerStats
var system_map
var galaxy_map
var system_map_toggle = false
var galaxy_map_toggle = false

func toggle_system_map():
	if system_map_toggle:
		close_system_map()
		system_map_toggle = false
	elif !system_map_toggle:
		open_system_map()
		close_galaxy_map()
		system_map_toggle = true

func open_system_map():
	var new_system_map = system_map_scene.instance()
	new_system_map.system = Global.current_system
	add_child(new_system_map)
	system_map = $SystemMap
	radar.hide()
	player_stats.hide()
	Global.starfield.hide()
	print("UI: System map opened")

func close_system_map():
	var get_children = get_children()
	for child in get_children:
		if child.is_in_group("system_map"):
			child.queue_free()
			Global.player.camera.current = true
			radar.show()
			player_stats.show()
			Global.starfield.show()
			print("UI: System map closed")

func toggle_galaxy_map():
	if galaxy_map_toggle:
		close_galaxy_map()
		galaxy_map_toggle = false
	elif !galaxy_map_toggle:
		open_galaxy_map()
		Global.loaded_system.hide()
		close_system_map()
		galaxy_map_toggle = true
		Global.loaded_system.show()

func open_galaxy_map():
	var new_galaxy_map = galaxy_map_scene.instance()
	add_child(new_galaxy_map)
	galaxy_map = $GalaxyMap
	radar.hide()
	player_stats.hide()
	Global.starfield.hide()
	print("UI: Galaxy map opened")

func close_galaxy_map():
	var get_children = get_children()
	for child in get_children:
		if child.is_in_group("galaxy_map"):
			child.queue_free()
			Global.player.camera.current = true
			radar.show()
			player_stats.show()
			Global.starfield.show()
			print("UI: Galaxy map closed")
