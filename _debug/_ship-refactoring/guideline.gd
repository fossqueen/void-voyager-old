extends Node2D


func _physics_process(_delta):
	scale.x = 32


func _draw():
	draw_line(Vector2.ZERO, Vector2(1, 0), Color(1, 1, 1, 1), 1, false)
