extends RayCast2D

var damage_per_second: int = 30
var is_casting := false setget set_is_casting 

# for some reason "interpolate_property" does not work right when on an NPC
var l: float
var r: float

func _ready() -> void:
	var parent = get_parent()
	l = 0.0 if parent.is_in_group("player") else 4.0
	r = 4.0 if parent.is_in_group("player") else 0.0
	set_physics_process(false)
	$Laser.points[1] = Vector2.ZERO


func _physics_process(delta) -> void:
	var cast_point := cast_to
	force_raycast_update()
	
	$CollisionParticles.emitting = is_colliding()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		$CollisionParticles.global_rotation = get_collision_normal().angle()
		$CollisionParticles.position = cast_point
		
		get_collider().damage(damage_per_second * delta)
	
	$Laser.points[1] = cast_point
	$BeamParticles.position = cast_point * 0.5
	$BeamParticles.process_material.emission_box_extents.x = cast_point.length() * 0.5

func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	$BeamParticles.emitting = is_casting
	$CastingParticles.emitting = is_casting
	
	if is_casting:
		appear()
	else:
		$CollisionParticles.emitting = false
		$BeamParticles.emitting = false
		$CastingParticles.emitting = false
		disappear()
	
	set_physics_process(is_casting)

func appear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Laser, "width", l, r, 0.1)
	$Tween.start()

func disappear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Laser, "width", r, l, 0.1)
	$Tween.start()
