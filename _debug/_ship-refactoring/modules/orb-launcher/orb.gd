extends RigidBody2D

var init_velocity
var speed: float = 100


func _draw():
	draw_circle(Vector2.ZERO, 32, Color(1, 0, 1, 0.25))
	draw_circle(Vector2.ZERO, 16, Color.white)
	draw_arc(Vector2.ZERO, 16, 0, deg2rad(360), 32, Color.fuchsia, 1, false)


func _integrate_forces(_state):
	apply_impulse(Vector2.ZERO.rotated(global_rotation), Vector2(speed, 0).rotated(global_rotation))
