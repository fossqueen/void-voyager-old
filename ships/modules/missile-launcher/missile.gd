extends RigidBody2D

export var color: Color = Color(1, 1, 1, 1)
export var length: int = 32
export var damage: int = 100
export var speed: int = 100

var explosion = load("res://_debug/explosion.tscn")

func _integrate_forces(_state):
	apply_impulse(Vector2(0, 0).rotated(rotation), Vector2(speed, 0).rotated(rotation))

func _on_Timer_timeout():
	explode()

func _draw():
	draw_line(Vector2(0,0), Vector2(length, 0), color, 1, false)

func _on_Projectile_body_shape_entered(_body_rid, _body, _body_shape_index, _local_shape_index):
	explode()

func explode():
	var new_explosion = explosion.instance()
	new_explosion.position = global_position
	new_explosion.damage = damage
	get_parent().call_deferred("add_child", new_explosion)
	queue_free()
