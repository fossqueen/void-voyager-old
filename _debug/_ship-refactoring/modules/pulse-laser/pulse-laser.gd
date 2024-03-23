extends RayCast2D


export var travel_distance: int = 4800
export var damage: int = 25
export var interval: float = 0.2

onready var laser = load("res://_debug/_ship-refactoring/modules/pulse-laser/laser.tscn")
onready var explosion = load("res://particles/explosion/explosionparticles2.tscn")
onready var timer = $Interval

var is_firing: bool = false setget set_is_firing

export var color: Color = Color.white


func _ready():
	timer.wait_time = interval
	cast_to.x = travel_distance


#func _unhandled_input(event):
#	if event.is_action("primary_fire"):
#		var fire = event.is_pressed()
#		is_firing = fire


func set_is_firing(fire: bool):
	is_firing = fire


func _process(_delta):
	#look_at(get_global_mouse_position())
	
	if is_firing and timer.is_stopped():
		fire()
		timer.start()


func fire():
	var distance = travel_distance
	
	if is_colliding():
		if get_collider() and get_collider().has_method("damage"):
			get_collider().damage(damage)
			distance = get_collider().global_position.distance_to(self.global_position)
			var new_explosion = explosion.instance()
			new_explosion.global_position = get_collision_point()
			new_explosion.modulate = color
			Global.main.add_child(new_explosion)
	
	$FireParticle.emitting = true
	var new_laser = laser.instance()
	new_laser.distance = distance
	new_laser.start_position = global_position
	new_laser.global_position = global_position
	new_laser.global_rotation = global_rotation
	new_laser.color = color
	Global.main.add_child(new_laser)
