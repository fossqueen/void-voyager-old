extends Node2D

var type
var color
var system
var camera
var select
var galaxy_map

const CENTER = Vector2(0, 0)
const RADIUS = 10

func _draw():
	draw_circle(CENTER, RADIUS, color)
	draw_arc(CENTER, RADIUS, 0, deg2rad(360), 11, color, 1)
	
	for object in system["Objects"]:
		if system["Objects"][object]["Type"] == "Black Hole":
			draw_arc(CENTER, RADIUS * 5, 0, deg2rad(360), 12, Color.fuchsia, 1, false)


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
	pass

func _on_ClickRegion_mouse_exited():
	pass


func _on_ClickRegion_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("primary_fire"):
		select.show()
		select.position = position
		galaxy_map.selected_system = system
