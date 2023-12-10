extends Node2D

var id: String
var mass: float
var type: String
var sub_type: String
var radius: float
var distance = 2000
export var rings: bool = false
var moons: bool
var moon_type: int = 1
var moon_distance = 1000
var system_name
var gravity = radius / 5.22

export var rotation_speed: float = 1

var center: Vector2 = Vector2(0, 0)
var color: Color = Color(1, 1, 1, 0.1)

func _init():
	add_to_group("planets")

# on ready
func _ready():
	$Body.position.x = distance
	$Body.scale = Vector2(radius / 512, radius / 512)
	$Body/GravityField.gravity = radius / 5.22

# draw guides
func _draw():
	draw_arc(center, distance, 0, deg2rad(360), 256, color)
	draw_line(center, Vector2(distance, 0), Color(1, 1, 1, 0.2), 1, false)

# physics process
func _physics_process(delta):
	rotation += (0.005 + int(1000.0 / int(distance))) * delta
	$Body/Sprite.rotation -= (rotation_speed / 48) * delta
