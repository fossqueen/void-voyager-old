extends Node2D

var planet
var type
var distance = 1000

export var rotation_speed: float = 1

var center: Vector2 = Vector2(0, 0)
var color: Color = Color(1, 1, 1, 0.1)

# draw guides
func _draw():
	draw_arc(center, distance, 0, deg2rad(360), 256, color)
	draw_line(center, Vector2(distance, 0), Color(1, 1, 1, 0.2), 1, false)

func _ready():
	$Body.position.x = distance
	$Body.scale = planet.scale / 2
	$Body/GravityField.gravity = planet.gravity / 2

func _physics_process(delta):
# warning-ignore:integer_division
	rotation += (0.015 + (1000 / int(distance))) * delta
	$Body/Sprite.rotation -= (rotation_speed / 48) * delta


func _on_Body_mouse_entered():
	$Body/UI/ToolTip/Label.text = get_parent().parent.id + "-A"
	$Body/UI/ToolTip.show()


func _on_Body_mouse_exited():
		$Body/UI/ToolTip.hide()
