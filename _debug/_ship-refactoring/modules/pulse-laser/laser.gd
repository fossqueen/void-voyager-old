extends Node2D

const PROJECTILE_SPEED: int = 18000

var distance: float = 4800
var start_position: Vector2

var color: Color = Color.white


func _draw():
	draw_line(Vector2.ZERO, Vector2(1 , 0), color, 1, false)


func _ready():
	$Anim.play("pulse")
	if distance < 150:
		scale.x = distance
	else:
		scale.x = 150


func _physics_process(_delta):
	if scale.x < distance:
		scale.x += 800
		


func _on_Timer_timeout():
	queue_free()
