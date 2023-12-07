extends Node2D

# save file
var _save := SaveFile.new()
var _save_exists: bool = false

# galaxy generator
var _galaxy_generator := GalaxyGenerator.new()

# scenes
onready var main_menu = load("res://ui/main-menu/main-menu.tscn")
onready var system = load("res://system/system.tscn")
onready var player = load("res://player/player.tscn")
onready var ui = load("res://ui/ui.tscn")
onready var galaxy_map = load("res://ui/galaxy-map/galaxy-map.tscn")

var loaded_system

# on ready
func _ready():
	Global.main = self
	load_save()
	init_main_menu()
	$UI/Margin/Bottom/Version.text = Global.VERSION

func _process(_delta):
	$UI/Margin/FPS.text = "fps: " + str(int(Engine.get_frames_per_second()))

# custom functions
func load_save() -> void:
	if _save.save_exists():
		_save.load_savefile()
		_save_exists = true

func create_save() -> void:
	_save.player = PlayerSave.new()
	_save.galaxy = Galaxy.new()
	_save.galaxy.galaxy = _galaxy_generator.initialize_galaxy(256, 256, 0.66)
	_save.player.current_system = randi() % _save.galaxy.galaxy.size()
	_save.write_savefile()
	print("Generated %s star systems" % _save.galaxy.galaxy.size())

func init_main_menu():
	var new_main_menu = main_menu.instance()
	if _save_exists:
		new_main_menu.save_exists = true
	add_child(new_main_menu)

func run_game():
	Global.save = _save
	#var maptest = galaxy_map.instance()
	#add_child(maptest)
	load_system()
	var new_player = player.instance()
	new_player.ship = _save.player.current_ship
	add_child(new_player)
	remove_child($MainMenu)

func load_system():
	var new_system = system.instance()
	new_system.system_id = _save.player.current_system
	new_system.data = _save.galaxy
	add_child(new_system)
	Global.loaded_system = $System

func hyperspace():
	var new_system = system.instance()
	if Global.save.player.current_system == -1:
		Global.save.player.current_system = 1
	else:
		Global.save.player.current_system += 1
	new_system.system_id = Global.save.player.current_system
	new_system.data = Global.save.galaxy
	remove_child($System)
	add_child(new_system)
	Global.player.global_position = Vector2(0, 0)
	loaded_system = $System
	print("Main: Jump complete")
