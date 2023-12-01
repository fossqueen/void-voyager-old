extends Node2D

var asteroid = load("res://asteroid/asteroid.tscn")

var count: int = 48
var center = Vector2(0, 0)
var radius = Vector2(1024, 0)
var rotation_speed: float
var radius_mod
var center_mod
var system_belt: bool = false

# base functions
func _ready():
	if system_belt:
		rotation_speed = rand_range(-0.001, 0.001)
	else:
		rotation_speed = rand_range(-0.1, 0.1)
	spawn_asteroids()

func _physics_process(delta):
	rotation += rotation_speed * delta

# custom functions
func spawn_asteroids():
	var step = 2 * PI / count
	for i in range(count):
		if system_belt:
			radius_mod = radius + Vector2(rand_range(-64, 64),0)
			center_mod = center + Vector2(rand_range(-768, 768), 0)
		else:
			radius_mod = radius + Vector2(rand_range(-64, 64),0)
			center_mod = center + Vector2(rand_range(-16, 16), 0)
		var spawn_position = center_mod + radius_mod.rotated(step * i)
		var new_asteroid = asteroid.instance()
		new_asteroid.position = spawn_position
		add_child(new_asteroid)
