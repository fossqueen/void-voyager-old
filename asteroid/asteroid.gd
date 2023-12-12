extends RigidBody2D

const radar_icon: String = "asteroid"
const MIN_SIZE: float = 0.05
const MAX_SIZE: float = 1.5

var size: float
var health: float = 100
var rotation_speed: float = 0

var points: PoolVector2Array = PoolVector2Array([Vector2(-64, -8), Vector2(-40, -48), Vector2(-8, -56), Vector2(48, -40), Vector2(56, 16), Vector2(8, 56), Vector2(-48, 40), Vector2(-64, -8)])
var explosion = load("res://_debug/explosionparticles.tscn")


func _draw():
	var width: int = 1
	draw_colored_polygon(points, Color.black)
	draw_polyline(points, Color.white, width)


func _ready():
	sleeping = true
	
	randomize()
	if randi() % 100 + 1 <= 33: # 1/3 chance to despawn. helps with 'natural' spacing
		queue_free()
	
	rotation_speed = rand_range(-0.5, 0.5)
	size = rand_range(MIN_SIZE, MAX_SIZE)
	
	global_scale = Vector2(size, size)
	health = health * size # scales health based on size
	$CollisionPolygon2D.polygon = points


func _physics_process(delta):
	rotation += rotation_speed * delta


func damage(amount) -> void: # need to eventually tweak the damage
	global_scale.x -= (amount * 0.002)
	global_scale.y -= (amount * 0.002)
	health -= amount

	if health <= 0:
		var new_explosion = explosion.instance()
		new_explosion.position = position
		new_explosion.modulate = Color.white
		new_explosion.z_index = -1
		get_parent().add_child(new_explosion)
		queue_free()


# signals
func _on_Asteroid_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index): # prevents asteroids from stacking on top of each other
	if body.is_in_group("asteroid"):
		if body.size > size:
			body.queue_free()
		else:
			queue_free()


func _on_Timer_timeout(): # contact monitor is only needed for the above signal. disables after setup
	contact_monitor = false
	$Timer.queue_free()


func _on_VisEnabler_viewport_exited(_viewport): # off-screen optimizations
	set_process(false)
	set_physics_process(false)
	set_physics_process_internal(false)
	set_deferred("mode", MODE_STATIC)
	$CollisionPolygon2D.disabled = true


func _on_VisEnabler_viewport_entered(_viewport): # off-screen optimizations
	set_process(true)
	set_physics_process(true)
	set_physics_process_internal(true)
	set_deferred("mode", MODE_KINEMATIC)
	$CollisionPolygon2D.disabled = false
