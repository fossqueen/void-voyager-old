extends Node2D

var points: PoolVector2Array


func _ready():
	scale = Vector2(1.25, 1.25)
	#$AnimationPlayer.play("pulse")

func _draw():
	draw_colored_polygon(points, Color(0, 1, 1, 0.25))
	#draw_polyline(points, Color.aqua, 1, false)
