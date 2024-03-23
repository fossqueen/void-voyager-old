tool
extends Node2D


export var points: PoolVector2Array


func _draw():
	if points:
		draw_colored_polygon(points, Color.black)
		draw_polyline(points, Color.white, 1, false)


func anim_thrust_play(input_vector):
	if input_vector.x > 0:
		$Animations/Thrusters/ForwardThrust.play("thrust")
	if input_vector.x < 0:
		$Animations/Thrusters/BackwardThrust.play("thrust")
	if input_vector.y > 0:
		$Animations/Thrusters/LeftThrust.play("thrust")
	if input_vector.y < 0:
		$Animations/Thrusters/RightThrust.play("thrust")


func anim_thrust_idle():
		$Animations/Thrusters/ForwardThrust.play("idle")
		$Animations/Thrusters/BackwardThrust.play("idle")
		$Animations/Thrusters/LeftThrust.play("idle")
		$Animations/Thrusters/RightThrust.play("idle")
