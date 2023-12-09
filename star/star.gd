extends Area2D

enum star_types{O, B, A, F, G, K, M}
export(star_types) var type = 3

var center: Vector2 = Vector2(0, 0)
export var radius: int = 512
var color: Color

var radar_icon = "star"

var system_name

func _ready():
	name = system_name
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
func _draw():
	draw_circle(center, radius, color)

func _on_Star_mouse_entered():
	$UI/ToolTip/Label.text = system_name
	$UI/ToolTip.show()

func _on_Star_mouse_exited():
	$UI/ToolTip.hide()
