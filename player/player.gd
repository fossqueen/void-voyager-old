extends RigidBody2D

var ship: Resource
export var points: PoolVector2Array
var buf_v: Vector2
var buf_v_length: float
var camera: Node
export var jump_range: float = 30.0

var reset_state: bool = false
var mouse_motion: bool = false
var flight_assist: bool = true

const FUEL_EFFICIENCY: float = 0.0015
const FLIGHT_ASSIST_AMOUNT: float = 0.6

func _ready() -> void:
	set_variables()


func _draw() -> void:
	draw_colored_polygon(ship.points, Color.black)
	draw_polyline(ship.points, Color.white, ship.width, ship.antialiased)


func _integrate_forces(_state) -> void:
	set_applied_torque(get_angle_to(get_global_mouse_position()) * pow(1.22, 100))
	store_velocity()
	reset()
	movement()

func _physics_process(_delta) -> void:
	#look()
	pass


func _unhandled_input(event):
	if Input.is_action_just_pressed("toggle_system_map"):
		$UI.toggle_system_map()
	
	if Input.is_action_just_pressed("toggle_galaxy_map"):
		$UI.toggle_galaxy_map()
	
	if Input.is_action_just_pressed("hyperspace"):
		pass
	
	if event.is_action("primary_fire"):
		var fire = event.is_pressed()
		$PulseLaser.is_firing = fire
	
	if event.is_action("secondary_fire"):
		var fire = event.is_pressed()
		$MiningLaser.is_casting = fire
	
	if Input.is_action_just_pressed("flight_assist"):
		toggle_flight_assist()
	
	if Input.is_action_just_pressed("ship_panel"):
		$UI.toggle_ship_panel()
		
	if event is InputEventMouseMotion:
		mouse_motion = true
	else:
		mouse_motion = false


func movement() -> void:
	var thrust_dir: Vector2 = Vector2(Input.get_axis("thrust_backward", "thrust_forward"), Input.get_axis("thrust_left", "thrust_right")) * Vector2(ship.speed, ship.speed)
	if thrust_dir != Vector2.ZERO and ship.fuel > 0:
		apply_impulse(Vector2.ZERO.rotated(rotation), thrust_dir.rotated(rotation))
		burn_fuel(FUEL_EFFICIENCY * Vector2(Input.get_axis("thrust_backward", "thrust_forward"), Input.get_axis("thrust_left", "thrust_right")).length())
		linear_damp = -1
		
		if thrust_dir.x > 0:
			$Animations/ForwardThrust.play("thrust")
		if thrust_dir.x < 0:
			$Animations/BackwardThrust.play("thrust")
		if thrust_dir.y > 0:
			$Animations/LeftThrust.play("thrust")
		if thrust_dir.y < 0:
			$Animations/RightThrust.play("thrust")
	
	else:
		$Animations/ForwardThrust.play("idle")
		$Animations/BackwardThrust.play("idle")
		$Animations/LeftThrust.play("idle")
		$Animations/RightThrust.play("idle")
		if flight_assist:
			linear_damp = FLIGHT_ASSIST_AMOUNT


func look() -> void:
	var look_dir: Vector2 = Vector2(Input.get_axis("look_left", "look_right"), Input.get_axis("look_up", "look_down"))
	if look_dir != Vector2.ZERO:
		if look_dir.length() >= 0.75:
			rotation = lerp_angle(rotation, look_dir.angle(), 0.5)
	if mouse_motion:
		look_at(get_global_mouse_position())


func toggle_flight_assist() -> void:
	if flight_assist:
		flight_assist = false
	elif !flight_assist:
		flight_assist = true


func burn_fuel(amount: float) -> void:
	if ship.fuel > 0:
		ship.fuel -= amount


func store_velocity() -> void:
	buf_v = linear_velocity
	buf_v_length = buf_v.length()


func damage(amount: float) -> void:
	if ship.shield > 0:
		ship.shield -= (amount)
		$Shield/AnimationPlayer.play("pulse")
		if ship.shield < 0:
			ship.health -= (ship.shield * -1)
			ship.shield = 0
	else:
		ship.health -= (amount)
	if ship.health <= 0:
		destroy()


func destroy() -> void:
	print("Ship destroyed")
	queue_free()


func reset() -> void:
	if reset_state:
		set_deferred("mode", MODE_KINEMATIC)
		position = Vector2(0, 0)
		set_deferred("mode", MODE_RIGID)
		reset_state = false


func set_variables() -> void:
	Global.player = self
	$UI/Radar.player = self
	$UI/PlayerStats.player = self
	camera = $Camera
	Global.ui = $UI
	$PulseLaser.parent = self


# Signals
func _on_Player_body_entered(body):
	print("Player: Collision detected with %s" % body)
	body.damage(buf_v_length)
	damage(buf_v_length / 100)


func _on_Scanner_body_entered(body):
	if body.is_in_group("radar_objects"):
		$UI/Radar.add_object(body)
	if body.is_in_group("npc"):
		$UI/Radar.add_object(body)


func _on_Scanner_body_exited(body):
	if body.is_in_group("radar_objects"):
		$UI/Radar.remove_object(body)
	if body.is_in_group("npc"):
		$UI/Radar.remove_object(body)
