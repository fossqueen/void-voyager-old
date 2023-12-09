extends RigidBody2D

var FACTION_COLORS = {
	'trader': Color.lightgreen,
	'pirate': Color.lightsalmon,
	'police': Color.lightblue
}

var FACTION_NAMES = FACTION_COLORS.keys()

onready var ship: Ship = Ship.new()
export (Resource) var src
export (Resource) var dst

var time_to_live: float = 60.0
var faction: String

var radar_icon: String = "npc"

func pos(r: float, t: float):
	return Vector2(r * cos(t), r * sin(t))

func _ready():
	position = pos(src.distance, src.rotation)
	faction = FACTION_NAMES[randi() % len(FACTION_NAMES)]

func _physics_process(delta):
	time_to_live -= delta
	if time_to_live <= 0:
		queue_free()
	if dst:
		look_at(pos(dst.distance, dst.rotation))
	else:
		look_at(Vector2(0, 0))

func _integrate_forces(_state):
	var speed = ship.speed / 2.0
	var target = Vector2(0, 0)
	if dst:
		target = pos(dst.distance, dst.rotation)
	linear_damp = -1
	if position.distance_to(target) < 3600.0:
		speed = ship.speed / 0.67
		linear_damp = 0.5
	apply_impulse(Vector2(0, 0).rotated(rotation), Vector2(speed, 0).rotated(rotation))

func _draw():
	draw_colored_polygon(ship.points, FACTION_COLORS[faction])
	draw_polyline(ship.points, Color.white, ship.width, false)

func damage(amount):
	ship.health -= (amount / 10)
	if ship.health <= 0:
		queue_free()
