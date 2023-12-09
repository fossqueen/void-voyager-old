extends RigidBody2D

onready var ship: Ship = Ship.new()
export (Resource) var src
export (Resource) var dst

var thrust_timer: float = 0.0

func pos(r: float, t: float):
	return Vector2(r * cos(t), r * sin(t))

func _ready():
	position = pos(src.distance, src.rotation)
	
func _physics_process(_delta):
	if dst:
		look_at(pos(dst.distance, dst.rotation))

func _integrate_forces(_state):
	var speed = ship.speed / 2.0
	var target = Vector2(0, 0)
	if dst:
		target = pos(dst.distance, dst.rotation)
	linear_damp = -1
	if position.distance_to(target) < 3000.0:
		speed = ship.speed / 0.67
		linear_damp = 0.5
	apply_impulse(Vector2(0, 0).rotated(rotation), Vector2(speed, 0).rotated(rotation))

func _draw():
	draw_colored_polygon(ship.points, Color.red)
	draw_polyline(ship.points, Color.white, ship.width, false)

func damage(amount):
	ship.health -= (amount / 10)
	if ship.health <= 0:
		destroy()

func destroy():
	queue_free()
