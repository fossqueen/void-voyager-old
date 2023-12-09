extends RigidBody2D

export (Resource) var ship = Ship.new()

func _ready():
	position = Vector2(randi() % 500, randi() % 500)	
	
func _draw():
	draw_colored_polygon(ship.points, Color.aliceblue)
	draw_polyline(ship.points, Color.white, ship.width, false)

func damage(amount):
	ship.health -= (amount / 10)
	if ship.health <= 0:
		destroy()

func destroy():
	print("Ship destroyed")
	queue_free()