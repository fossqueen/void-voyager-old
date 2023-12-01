extends Area2D

onready var parent = get_parent()
onready var type = parent.type

var texture = load("res://planet/textures/moon.png")

var radar_icon = "moon"

# Border variables
var center: Vector2 = Vector2(0, 0)
var radius: int = 512
var start_angle: int = 0
var end_angle: float = deg2rad(360)
var color: Color = Color(1, 1, 1, 1)
var point_count: int = 100
var width: int = 1
var antialiased: bool = false

func _draw():
	draw_arc(center, radius, start_angle, end_angle, point_count, color, width, antialiased)

func _ready():
	configure_moon()

func configure_moon():
	$Sprite.texture = texture
	self.self_modulate = Color(0.75, 0.75, 0.75, 1)
	$Sprite.self_modulate = self.self_modulate
	
