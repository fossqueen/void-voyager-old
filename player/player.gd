extends RigidBody2D

var ship
export var points: PoolVector2Array
var buf_v
var buf_v_length
var camera
var reset_state = false
var flight_assist: bool = true

onready var laser = load("res://_debug/laser.tscn")
onready var rocket = load("res://_debug/rocket.tscn")

# base functions
func _ready():
	set_variables()

func _draw():
	draw_colored_polygon(points, ship.color_black)
	draw_polyline(points, ship.color_white, ship.width, ship.antialiased)

func _integrate_forces(_state):
	movement()
	store_velocity()
	if reset_state:
		set_deferred("mode", MODE_KINEMATIC)
		position = Vector2(0, 0)
		set_deferred("mode", MODE_RIGID)
		reset_state = false

func _physics_process(_delta):
	look()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("toggle_system_map"):
		$UI.toggle_system_map()
	if Input.is_action_just_pressed("toggle_galaxy_map"):
		print("ADD HERE toggle galaxy map")
		#$UI.toggle_galaxy_map()
	if Input.is_action_just_pressed("hyperspace"):
		$UI/Radar.remove_all_objects()
		reset_state = true
		Global.main.hyperspace()
		$UI/Radar.get_objects()
	if Input.is_action_just_pressed("primary_fire"):
		var new_laser = laser.instance()
		new_laser.position = position
		new_laser.rotation = global_rotation
		get_parent().add_child(new_laser)
	if Input.is_action_just_pressed("secondary_fire"):
		var new_rocket = rocket.instance()
		new_rocket.position = position
		new_rocket.rotation = global_rotation
		new_rocket.linear_velocity = linear_velocity
		get_parent().add_child(new_rocket)
	toggle_flight_assist()

# custom functions
func movement():
	if Input.is_action_pressed("thrust") and ship.fuel > 0:
		apply_impulse(Vector2(0, 0).rotated(rotation), Vector2(ship.speed, 0).rotated(rotation))
		$Animations/AnimationPlayer.play("thrust")
		burn_fuel(0.0015)
		linear_damp =  -1
	else:
		$Animations/AnimationPlayer.play("idle")
		if flight_assist:
			linear_damp = 1

func look():
	look_at(get_global_mouse_position())

func toggle_flight_assist():
	if Input.is_action_pressed("flight_assist"):
		if flight_assist:
			flight_assist = false
		elif !flight_assist:
			flight_assist = true

func burn_fuel(amount):
	if ship.fuel > 0:
		ship.fuel -= amount

func store_velocity():
	buf_v = linear_velocity
	buf_v_length = buf_v.length()

func damage(amount):
	ship.health -= (amount / 10)
	if ship.health <= 0:
		destroy()

func destroy():
	print("Ship destroyed")
	queue_free()

func set_variables():
	Global.player = self
	$UI/Radar.player = self
	$UI/PlayerStats.player = self
	camera = $Camera

# signals
func _on_Player_body_entered(body):
	print("Player: Collision detected with %s" % body)
	body.damage(buf_v_length)
	damage(buf_v_length)

func _on_Scanner_body_entered(body):
	if body.is_in_group("radar_objects"):
		$UI/Radar.add_object(body)

func _on_Scanner_body_exited(body):
	if body.is_in_group("radar_objects"):
		$UI/Radar.remove_object(body)
