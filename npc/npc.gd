extends RigidBody2D

const radar_icon: String = "npc"

const NPC_FULL_SPEED = Vector2(50000, 0)
const FACTION_COLORS = {
	'trader': Color.lightgreen,
	'pirate': Color.lightsalmon,
	'police': Color.lightblue
}

export (Resource) var src
export (Resource) var dst

export var faction: String = random_choice(FACTION_COLORS.keys())
export var target: Vector2 = Vector2(0, 0)
export var offset: float = 250.0 # stopping distance

var ship: Ship = Ship.new()


func random_choice(collection):
	return collection[randi() % collection.size()]

func damage(amount):
	ship.health -= (amount / 10)
	if ship.health <= 0:
		queue_free()

func get_faction_color():
	return FACTION_COLORS[faction]


func _init():
	add_to_group("npcs")


func _ready():
	name = random_choice(Global.npc_name_pool)
	if is_instance_valid(src):
		position = polar2cartesian(src.distance, src.rotation)
	if is_instance_valid(dst):
		offset = dst.radius


func _process(_delta):
	if is_instance_valid(dst):
		target = polar2cartesian(dst.distance, dst.rotation)
	if ship.fuel <= 0:
		queue_free()


func _integrate_forces(_state):
	var distance = position.distance_to(target)
	var speed = NPC_FULL_SPEED

	if distance > offset:
		linear_damp = 0.01 # they can't handle -1
		if distance < offset * 6:
			linear_damp = 0.6
		elif distance < offset * 12:
			linear_damp = 0.6
			speed.x = ship.speed / 1.5
		look_at(target)
		$Animations/AnimationPlayer.play("thrust")
		ship.fuel -= 0.015
		apply_central_impulse(speed.rotated(rotation))
	else:
		linear_damp = -1
		speed.x = 0.0
		$Animations/AnimationPlayer.play("idle")
		if distance < offset / 2.0:
			queue_free()


func _draw():
	draw_colored_polygon(ship.points, FACTION_COLORS[faction])
	draw_polyline(ship.points, Color.white, ship.width, false)
