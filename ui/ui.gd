extends CanvasLayer

onready var system_map_scene = load("res://ui/system-map/system-map.tscn")
onready var galaxy_map_scene = load("res://ui/galaxy-map/galaxy-map.tscn")
onready var ship_panel_scene = load("res://ui/ship-panel/ship-panel.tscn")

onready var radar = $Radar
onready var player_stats = $PlayerStats
var system_map
var galaxy_map
var ship_panel
var system_map_toggle = false
var galaxy_map_toggle = false
var ship_panel_toggle = false

func toggle_system_map():
	if system_map_toggle:
		close_system_map()
	elif !system_map_toggle:
		close_galaxy_map()
		close_ship_panel()
		open_system_map()


func open_system_map():
	var new_system_map = system_map_scene.instance()
	new_system_map.system = Global.current_system
	add_child(new_system_map)
	system_map = $SystemMap
	radar.hide()
	player_stats.hide()
	Global.starfield.hide()
	system_map_toggle = true
	print("System Map: initialized")

func close_system_map():
	var get_children = get_children()
	for child in get_children:
		if child.is_in_group("system_map"):
			child.queue_free()
			Global.player.camera.current = true
			radar.show()
			player_stats.show()
			Global.starfield.show()
			system_map_toggle = false
			print("System Map: terminated")

func toggle_galaxy_map():
	if galaxy_map_toggle:
		close_galaxy_map()
		Global.loaded_system.show()
	elif !galaxy_map_toggle:
		close_system_map()
		open_galaxy_map()
		Global.loaded_system.hide()



func open_galaxy_map():
	var new_galaxy_map = galaxy_map_scene.instance()
	add_child(new_galaxy_map)
	galaxy_map = $GalaxyMap
	radar.hide()
	player_stats.hide()
	Global.starfield.hide()
	galaxy_map_toggle = true
	
	print("Galaxy Map: initialized")

func close_galaxy_map():
	var get_children = get_children()
	for child in get_children:
		if child.is_in_group("galaxy_map"):
			child.queue_free()
			Global.player.camera.current = true
			radar.show()
			player_stats.show()
			Global.starfield.show()
			galaxy_map_toggle = false
			print("Galaxy Map: terminated")

func toggle_ship_panel():
	if ship_panel_toggle:
		close_ship_panel()
	elif !ship_panel_toggle:
		close_system_map()
		close_galaxy_map()
		open_ship_panel()


func open_ship_panel():
	var new_ship_panel = ship_panel_scene.instance()
	add_child(new_ship_panel)
	ship_panel = $ShipPanel
	radar.hide()
	player_stats.hide()
	ship_panel_toggle = true
	print("UI: Ship panel opened")

func close_ship_panel():
	var get_children = get_children()
	for child in get_children:
		if child.is_in_group("ship_panel"):
			child.queue_free()
			radar.show()
			player_stats.show()
			ship_panel_toggle = false
			print("UI: Ship panel closed")
