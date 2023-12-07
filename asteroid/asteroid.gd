extends RigidBody2D

var size: float
var health: float = 100
var rotation_speed: float = 1
var min_size: float = 0.05
var max_size: float = 1.5

var points: PoolVector2Array = PoolVector2Array([Vector2(-64, -8), Vector2(-40, -48), Vector2(-8, -56), Vector2(48, -40), Vector2(56, 16), Vector2(8, 56), Vector2(-48, 40), Vector2(-64, -8)])

var radar_icon: String = "asteroid"

var explosion = load("res://_debug/explosionparticles.tscn")

# base functions
func _draw():
	var color_white: Color = Color(1.0, 1.0, 1.0)
	var color_black: Color = Color(0.0, 0.0, 0.0)
	var width: int = 1
	draw_colored_polygon(points, color_black)
	draw_polyline(points, color_white, width)

func _ready():
	sleeping = true
	randomize()
	if int(rand_range(0, 100)) <= 33:
		queue_free()
	
	rotation_speed = rand_range(-0.5, 0.5)
	size = rand_range(min_size, max_size)
	global_scale = Vector2(size, size)
	health = health * size
	$CollisionPolygon2D.polygon = points

func _physics_process(delta):
	rotation += rotation_speed * delta

# custom functions
func damage(amount):
	global_scale.x -= (amount * 0.001)
	global_scale.y -= (amount * 0.001)
	health -= amount
	var new_explosion = explosion.instance()
	new_explosion.position = position
	new_explosion.modulate = Color(1, 1, 1)
	new_explosion.z_index = -1
	get_parent().add_child(new_explosion)
	if health <= 0:
		queue_free()

# signals
func _on_Asteroid_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.is_in_group("asteroid"):
		if body.size > size:
			body.queue_free()
		else:
			queue_free()

func _on_Timer_timeout():
	contact_monitor = false
	$Timer.queue_free()

func _on_VisEnabler_viewport_exited(_viewport):
	set_process(false)
	set_physics_process(false)
	#$CollisionPolygon2D.disabled = true
	contact_monitor = false
	sleeping = true

func _on_VisEnabler_viewport_entered(_viewport):
	set_process(true)
	set_physics_process(true)
	#$CollisionPolygon2D.disabled = false
	contact_monitor = true
	sleeping = false
