tool
extends Control

var center = rect_size / 2
var radius = 128
var angle = deg2rad(360)
var points = 100
var color = Color(1.0 ,1.0, 1.0)

func _draw():
	draw_circle(center, radius, Color(0, 0, 0, 0.25))
	draw_arc(center, radius, 0, angle, points, color, 0)
	var count = 4
	var multi = 1
	for _i in range(count):
		draw_arc(center, radius * multi, 0, angle, points * multi, color * multi, 0)
		multi -= 0.25
