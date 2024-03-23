extends Area2D

onready var parent = get_parent()
onready var type = parent.type
onready var sub_type = parent.sub_type
onready var rings = parent.rings
onready var moons = parent.moons

# textures and scenes
var gas_giant_texture = load("res://planet/textures/gas-giant.png")
var terrestrial_texture = load("res://planet/textures/terrestrial.png")
var waterworld_texture = load("res://planet/textures/oceanic.png")
var clouds = load("res://planet/textures/clouds.tscn")
var asteroid_spawner = load("res://asteroid/asteroid-spawner.tscn")
var moon_spawner = load("res://planet/moon.tscn")
var station_spawner = load("res://station/station.tscn")
export var debug_color: Color

var radar_icon = "planet"

# border variables
var center: Vector2 = Vector2(0, 0)
var radius: int = 512
var start_angle: int = 0
var end_angle: float = deg2rad(360)
var color: Color = Color(1, 1, 1, 1)
var point_count: int = 100
var width: int = 1
var antialiased: bool = false 

# on ready
func _ready():
	configure_planet()

# draw border
func _draw():
	draw_arc(center, radius, start_angle, end_angle, point_count, color, width, antialiased)

# custom functions
func configure_planet():
	if type == "Gas Giant":
		$Sprite.texture = gas_giant_texture
		self_modulate = Color(0.27, 1, 0)
		$Sprite.self_modulate = Color(0.27, 1, 0)
	if type == "Terrestrial":
		$Sprite.texture = terrestrial_texture
		if sub_type == "Terren":
			self_modulate = Color(1, 0, 0.32)
			$Sprite.self_modulate = Color(1, 0, 0.32)
		elif sub_type == "Waterworld":
			$Sprite.texture = waterworld_texture
			self_modulate = Color(0, 0.32, 1)
			$Sprite.self_modulate = Color(0, 0.32, 1)
		elif sub_type == "Ice-Planet":
			self_modulate = Color(0, 1, 1)
			$Sprite.self_modulate = Color(0, 1, 1)
		elif sub_type == "Earth-like":
			self_modulate = Color(0, 0.32, 1)
			$Sprite.self_modulate = Color(0.1, 0.85, 0)
			var new_clouds = clouds.instance()
			add_child(new_clouds)
	if rings:
		var spawn_asteroids = asteroid_spawner.instance()
		spawn_asteroids.radius = Vector2(parent.radius * 3, 0)
		spawn_asteroids.count = int(radius * 0.75)
		spawn_asteroids.position.x = parent.distance
		parent.call_deferred("add_child", spawn_asteroids)
	if moons:
		var spawn_moon = moon_spawner.instance()
		spawn_moon.planet = self
		spawn_moon.type = parent.moon_type
		spawn_moon.distance = parent.moon_distance
		spawn_moon.rotation = deg2rad(rand_range(0, 360))
		add_child(spawn_moon)
	if not parent.station == {}:
		if parent.station["Exists"] == true:
			var new_station = station_spawner.instance()
			new_station.station_name = parent.station["Name"]
			new_station.station_distance = parent.station["Distance"]
			new_station.station_size = parent.station["Size"]
			new_station.station_state = parent.station["State"]
			add_child(new_station)
		

# signals
func _on_Body_mouse_entered():
	$UI/ToolTip/Label.text = (parent.system_name + "-" + parent.id) + ("\ntype: " + (sub_type if sub_type != "None" else type)) + ("\ndistance: %d" %parent.distance + " a/u")
	$UI/ToolTip.show()

func _on_Body_mouse_exited():
	$UI/ToolTip.hide()
