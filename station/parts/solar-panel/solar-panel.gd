tool
extends Node2D

export var points: PoolVector2Array
export var points2: PoolVector2Array

func _draw():
	draw_colored_polygon(points, Color.black)
	draw_polyline(points, Color.white, 1, false)
	draw_multiline(points2, Color.white, 1, false)
