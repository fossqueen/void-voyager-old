extends Node2D

var count
var distance
onready var asteroid_spawner = load("res://asteroid/asteroid-spawner.tscn")

# base functions
func _ready():
	var new_spawner = asteroid_spawner.instance()
	new_spawner.radius = Vector2(distance, 0)
	new_spawner.count = distance / 4
	new_spawner.system_belt = true
	add_child(new_spawner)

#func _draw():
#	draw_arc(Vector2(0, 0), distance, 0, deg2rad(360), 256, Color(1, 1, 0, 0.75))
