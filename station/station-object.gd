extends Area2D

var radar_icon = "station"


func _draw():
	draw_circle(Vector2.ZERO, 64, Color.orchid)
