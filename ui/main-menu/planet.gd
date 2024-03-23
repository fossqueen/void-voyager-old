extends Area2D


func _draw():
	draw_arc(Vector2.ZERO, 512, 0, deg2rad(360), 100, Color.blue, 1, false)
