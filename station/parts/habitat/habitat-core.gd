tool
extends Node2D

func _draw():
	draw_circle(Vector2.ZERO, 64, Color.black)
	draw_arc(Vector2.ZERO, 64, 0, deg2rad(360), 50, Color.white, 1, false)
