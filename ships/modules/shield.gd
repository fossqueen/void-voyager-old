extends Node2D

var center: Vector2 = Vector2(0, 0)
var radius: float = 50
var start_angle: float = 0
var end_angle: float = deg2rad(360)
var point_count: int = 16
var color: Color = Color.cyan
var width: int = 1
var antialiased: bool = false

var recharging: bool = false


func _draw():
	draw_circle(center, radius, Color(0, 1, 1, 0.2))
	draw_arc(center, radius, start_angle, end_angle, point_count, color, width, antialiased)


func _ready():
	$AnimationPlayer.play("idle")


func _process(_delta):
	if recharging:
		Global.player.ship.shield += 1
		if Global.player.ship.shield >= 100:
			Global.player.ship.shield = 100
			recharging = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "pulse":
		$AnimationPlayer.play("idle")


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "idle":
		$Timer.start()


func _on_Timer_timeout():
	recharging = true
