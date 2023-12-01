extends Area2D

var damage
var explosion = load("res://_debug/explosionparticles.tscn")

func _ready():
	var new_explosion = explosion.instance()
	new_explosion.position = global_position
	get_parent().add_child(new_explosion)

func _on_ExplosionTimer_timeout():
	queue_free()

func _on_Explosion_body_entered(body):
	body.damage(damage)
