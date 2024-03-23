extends RigidBody2D


const TORQUE_MODIFIER: float = pow(1.22, 100) # 'sweet spot' for the mouse-look torque amount
const FUEL_EFFICIENCY: float = 0.0005

export var fuel: float
export var thrust_amount: int = 75000

onready var art = $Art
onready var art_thrust = $Art/Animations/Thrust
onready var art_thrust_lat = $Art/Animations/ThrustLat
onready var collision = $Collision

var input_vector: Vector2
var flight_assist: bool = true


func _ready() -> void:
	if art.points:
		collision.polygon = art.points
		$Shield.points = art.points


func _integrate_forces(_state) -> void:
	set_applied_torque(get_angle_to(get_global_mouse_position()) * TORQUE_MODIFIER) # physics friendly mouse-look
	
	input_vector = Vector2(Input.get_axis("thrust_backward", "thrust_forward"), Input.get_axis("thrust_left", "thrust_right"))
	if input_vector != Vector2.ZERO and fuel > 0: # checks for input and thrusts in input's direction if fuel
		apply_impulse(Vector2.ZERO.rotated(rotation), input_vector.rotated(rotation) * Vector2(thrust_amount, thrust_amount))
		fuel -= input_vector.length() * FUEL_EFFICIENCY
		
		linear_damp = -1 
		
		art_thrust.emitting = true if input_vector.x != 0 else false
		art_thrust_lat.emitting = true if input_vector.y != 0 else false
		thrust_directions()
	
	else:
		
		linear_damp = 1 if flight_assist else -1
		
		art_thrust.emitting = false
		art_thrust_lat.emitting = false


func thrust_directions():
	if input_vector.x < 0:
		art_thrust.rotation_degrees = 180
	else:
		art_thrust.rotation_degrees = 0
	
	if input_vector.y < 0:
		art_thrust_lat.rotation_degrees = -90
	else:
		art_thrust_lat.rotation_degrees = 90
	
