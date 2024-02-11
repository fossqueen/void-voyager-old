extends Node2D

export var system_id = 0

onready var asteroid_belt = load("res://asteroid/asteroid-belt.tscn")
onready var planet = load("res://planet/planet.tscn")
onready var star = load("res://star/star.tscn")
onready var system_map = load("res://ui/system-map/system-map.tscn")

var data: Resource
const min_distance = 3000
var system
var map_open = false

func _ready():
	system = data.galaxy[system_id]
	init_star()
	init_objects()
	Global.current_system = system
	Global.starfield = $Starfield

func init_star():
	var system_star = system["Star"]
	var new_star = star.instance()
	new_star.radius = system_star["Radius"]
	if system_star["Mass"] > 500:
		new_star.type = 6
	elif system_star["Mass"] > 450:
		new_star.type = 5
	elif system_star["Mass"] > 400:
		new_star.type = 4
	elif system_star["Mass"] > 350:
		new_star.type = 3
	elif system_star["Mass"] > 300:
		new_star.type = 2
	elif system_star["Mass"] > 250:
		new_star.type = 1
	else:
		new_star.type = 0
	new_star.system_name = system["Name"]
	add_child(new_star)

func init_objects():
	for i in system["Objects"]:
		if system["Objects"][i]["Name"] == "Belt":
			var new_belt = asteroid_belt.instance()
			new_belt.distance = system["Objects"][i]["Distance"]
			add_child(new_belt)
			continue
		
		var new_planet = planet.instance()
		new_planet.id = system["Objects"][i]["Name"]
		new_planet.mass = system["Objects"][i]["Mass"]
		new_planet.type = system["Objects"][i]["Type"]
		new_planet.sub_type = system["Objects"][i]["SubType"]
		new_planet.radius = system["Objects"][i]["Radius"]
		new_planet.distance = system["Objects"][i]["Distance"]
		new_planet.rings = system["Objects"][i]["Rings"]
		new_planet.moons = system["Objects"][i]["Moons"]
		new_planet.moon_type = system["Objects"][i]["MoonType"]
		new_planet.moon_distance = system["Objects"][i]["MoonDistance"]
		new_planet.rotation_speed = rand_range(0.1, 1)
		new_planet.rotation = deg2rad(rand_range(0, 360))
		new_planet.system_name = system["Name"]
		new_planet.name = system["Name"] + system["Objects"][i]["Name"]
		new_planet.station = system["Objects"][i]["Station"]
		add_child(new_planet)
