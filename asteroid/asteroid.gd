extends KinematicBody2D

const radar_icon: String = "asteroid"
const MIN_SIZE: float = 0.05
const MAX_SIZE: float = 1.5

var size: float = 1
var health: float = 100
var rotation_speed: float = 0

export var points: PoolVector2Array = PoolVector2Array([Vector2(-64, -8), Vector2(-40, -48), Vector2(-8, -56), Vector2(48, -40), Vector2(56, 16), Vector2(8, 56), Vector2(-48, 40), Vector2(-64, -8)])
export var explosion: PackedScene
export var item: PackedScene


func _draw():
	draw_colored_polygon(points, Color.black)
	draw_polyline(points, Color.white, 1)


func _ready():
	rotation_speed = rand_range(-0.5, 0.5)
	size = rand_range(MIN_SIZE, MAX_SIZE)
	
	global_scale = Vector2(size, size)
	health = health * size # scales health based on size
	$CollisionPolygon2D.polygon = points
	$OverlapChecker/CollisionPolygon2D2.polygon = points


func _physics_process(delta):
	rotation += rotation_speed * delta


func damage(amount) -> void: # need to eventually tweak the damage
	global_scale.x -= (amount * 0.002)
	global_scale.y -= (amount * 0.002)
	health -= amount

	if health <= 0:
		var drop_item = item.instance() # dirty randomized item drop, will need to change
		drop_item.itemID = randi() % 6
		drop_item.position = position
		get_parent().call_deferred("add_child", drop_item)
		
		var new_explosion = explosion.instance() # dirty explosion particles implementation
		new_explosion.position = position
		new_explosion.modulate = Color.white
		new_explosion.z_index = -1
		get_parent().call_deferred("add_child", new_explosion)
		
		queue_free()


# signals
func _on_OverlapChecker_body_entered(body): # used to prevent asteroids from overlapping each other. removed after timer stops
	if body.is_in_group("asteroid"):
		if body == self:
			return
		if body.size > size:
			body.queue_free()
		else:
			queue_free()


func _on_Timer_timeout(): 
	$OverlapChecker.queue_free()
	$Timer.queue_free()


func _on_VisEnabler_viewport_exited(_viewport): # off-screen optimizations
	set_process(false)
	set_physics_process(false)
	set_physics_process_internal(false)


func _on_VisEnabler_viewport_entered(_viewport): # off-screen optimizations
	set_process(true)
	set_physics_process(true)
	set_physics_process_internal(true)
