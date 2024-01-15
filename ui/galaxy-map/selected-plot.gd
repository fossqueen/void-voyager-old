extends Node2D

func _draw():
	draw_polyline(PoolVector2Array([Vector2(8, 4), Vector2(8, 8), Vector2(4, 8)]), Color.green, 1, false)
	draw_polyline(PoolVector2Array([Vector2(-4, -8), Vector2(-8, -8), Vector2(-8, -4)]), Color.green, 1, false)
	draw_polyline(PoolVector2Array([Vector2(-4, 8), Vector2(-8, 8), Vector2(-8, 4)]), Color.green, 1, false)
	draw_polyline(PoolVector2Array([Vector2(8, -4), Vector2(8, -8), Vector2(4, -8)]), Color.green, 1, false)
