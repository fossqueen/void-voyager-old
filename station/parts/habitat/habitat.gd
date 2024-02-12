tool
extends Node2D

func _draw():
	#draw_colored_polygon(PoolVector2Array([ Vector2(-4, -72), Vector2(4, -72), Vector2(4, 72), Vector2(-4, 72), Vector2(-4, -72) ]), Color.black)
	#draw_polyline(PoolVector2Array([ Vector2(-4, -72), Vector2(4, -72), Vector2(4, 72), Vector2(-4, 72), Vector2(-4, -72) ]), Color.white, 1, false)
	
	draw_arc(Vector2.ZERO, 68, 0, deg2rad(361), 50, Color.black, 8, false)
	draw_arc(Vector2.ZERO, 72, 0, deg2rad(360), 50, Color.white, 1, false)
	draw_arc(Vector2.ZERO, 64, 0, deg2rad(360), 50, Color.white, 1, false)

func _process(delta):
	rotation += 0.015 * delta
