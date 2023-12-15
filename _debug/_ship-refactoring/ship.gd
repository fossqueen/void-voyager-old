extends RigidBody2D

export(Resource) onready var ship: Resource

onready var camera = $Camera
onready var collider = $Collider

func _draw():
	draw_colored_polygon(ship.POINTS, Color.black)
	draw_polyline(ship.POINTS, Color.white, 1.0, false)


func _ready():
	ship.init_ship()
	collider.polygon = ship.POINTS
	
	print("health: %s" % ship.health)
	print("shield: %s" % ship.shield)
	print("fuel: %s" %ship.fuel)
