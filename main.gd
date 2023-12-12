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
onready var npc = preload('res://npc/npc.tscn')
onready var ui = load("res://ui/ui.tscn")
onready var galaxy_map = load("res://ui/galaxy-map/galaxy-map.tscn")

var npc_spawn_timer: float = 0.0
var menu_active: bool = true

# on ready
func _ready() -> void:
	Global.main = self
	load_save()
	init_main_menu()
	$UI/Margin/Bottom/Version.text = Global.VERSION


func _process(delta) -> void:
	if not menu_active:
		npc_spawn_timer -= delta
		if npc_spawn_timer <= 0.0:
			spawn_npc()
			npc_spawn_timer = 3.0
	$UI/Margin/FPS.text = "fps: " + str(int(Engine.get_frames_per_second()))


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


func init_main_menu() -> void:
	menu_active = true
	var new_main_menu = main_menu.instance()
	if _save_exists:
		new_main_menu.save_exists = true
	add_child(new_main_menu)


func run_game() -> void:
	Global.save = _save
	var new_player = player.instance()
	new_player.ship = _save.player.current_ship
	add_child(new_player)
	remove_child($MainMenu)
	load_system()
	Global.ui.radar.get_objects()
	menu_active = false


func spawn_npc() -> void:
	if not Global.planets.empty():
		var entity = npc.instance()
		# use the planet's body as the origin and future targets, it has the real coordinates
		entity.faction = randi() % 3 # 4 factions so far, this is a temporary line
		entity.origin = Global.planets[randi() % Global.planets.size()].get_node("Body")
		
		add_child(entity)


func load_system() -> void:
	var tree = get_tree()
	var cleanup = tree.get_nodes_in_group("system") + tree.get_nodes_in_group("npc")
	for entity in cleanup:
		remove_child(entity)

	var new_system = system.instance()
	
	new_system.system_id = Global.save.player.current_system
	new_system.data = Global.save.galaxy
	add_child(new_system)

	Global.loaded_system = $System
	Global.player.global_position = Vector2(0, 0)


func hyperspace() -> void:
	Global.save.player.current_system = randi() % 512
	load_system()
