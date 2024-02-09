extends Node2D

var points: PoolVector2Array = PoolVector2Array()

func _draw():
	draw_polyline(points, Color.white, 1, false)
