extends Node2D

var type
var color
var system

const CENTER = Vector2(0, 0)
const RADIUS = 16

func _draw():
	draw_circle(CENTER, RADIUS, color)
	draw_arc(CENTER, RADIUS, 0, deg2rad(360), 11, color, 1)

func _ready():
	if type == 0:
		color = Color(0.00, 0.57, 0.78)
	elif type == 1:
		color = Color(0.00, 0.77, 0.98)
	elif type == 2:
		color = Color(1.0, 1.0, 1.0)
	elif type == 3:
		color = Color(1.0, 0.92, 0.46)
	elif type == 4:
		color = Color(1.0, 0.92, 0.16)
	elif type == 5:
		color = Color(1.00, 0.63, 0.00)
	elif type == 6:
		color = Color(1.00, 0.00, 0.32)

func _on_ClickRegion_mouse_entered():
	var player_system = Global.save.galaxy.galaxy[Global.save.player.current_system]
	var player_system_position = Vector2(player_system["Coordinates"]["X"], player_system["Coordinates"]["Y"])
	var system_position = Vector2(system["Coordinates"]["X"], system["Coordinates"]["Y"])
	
	print(system["Name"])
	print("Points of interest: " + str(system["Objects"].size()))
	print("Distance from current position: " + str(int(player_system_position.distance_to(system_position))) + " ly")

func _on_ClickRegion_mouse_exited():
	pass
