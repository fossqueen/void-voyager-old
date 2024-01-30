extends Area2D

export var color: Color = Color(1, 1, 1, 1)
export var length: int = 16
export var damage: int = 100
export var speed: int = 100

var parent

const PROJECTILE_SPEED: int = 8000

func _process(delta):
	position += Vector2(1, 0).rotated(rotation) * PROJECTILE_SPEED * delta

func _on_Timer_timeout():
	queue_free()

func _draw():
	draw_line(Vector2(0,0), Vector2(length, 0), color, 1, false)

func _on_Laser_body_entered(body):
	if body == parent:
		pass
	else:
		body.damage(damage)
		var explosion = load("res://particles/explosion/explosionparticles.tscn")
		var new_explosion = explosion.instance()
		new_explosion.global_position = global_position
		new_explosion.modulate = Color(1, 0, 1)
		Global.main.add_child(new_explosion)
		queue_free()
