extends RigidBody2D
const radar_icon: String = "npc"

# maps to the enum values below
const FACTION_NAMES = [ "pirate", "police", "merchant", "player" ]
const FACTION_COLORS = [ Color.red, Color.blue, Color.green, Color.orange ]
const NPC_NAMES_POOL = [ "lisa", "bart", "maggie", "homer", "marge", "millhouse", "martin", "ralph", "burns", "smithers", "barney", "grampa", "flanders", "wiggum", "lovejoy", "willie", "apu", "bob", "skinner", "krabappel", "krusty", "nelson", "quimby", "brockman", "riviera", "otto", "patty", "selma", "frink" ]
const NPC_ENEMY_MAX = 3

# enums are a good way to manage state, as a bonus they also show up in the template
enum FACTIONS { pirate, police, merchant, player }
enum BEHAVIOR { pissed, chill, scared, traveling }

onready var stopping: float = 750.0 # stop 750m away by default
onready var ship: Ship = Ship.new() # ship resource
onready var is_firing: bool = false
onready var asteroids: Array = [] # queue of asteroids

onready var targets: Dictionary # dict of all visible targets
onready var crosshairs: Vector2 # direction of the ship

export (BEHAVIOR) var behavior = BEHAVIOR.chill # controls behavior (based on factions)
export (FACTIONS) var faction = FACTIONS.player # NPCs faction (player for multiplayer)

export (Resource) var attack # resource to attack
export (Resource) var target # resource to point at
export (Resource) var origin # resource to spawn from


func attack_target(amount) -> void:
	if is_instance_valid(attack) and is_firing:
		$MiningLaser.damage_per_second = amount
		$MiningLaser.set_is_casting(true)
	else:
		$MiningLaser.set_is_casting(false)


func damage(amount) -> void:
	ship.health -= (amount / 10)
	if ship.health <= 0:
		queue_free()


func thrust(amount) -> void:
	if amount > 0:
		ship.fuel -= (amount * 1e-5)
		apply_central_impulse(Vector2(amount, 0).rotated(rotation))
		$Animations/AnimationPlayer.play("thrust")
	else:
		$Animations/AnimationPlayer.play("idle")


func random_array_choice(array: Array):
	randomize()
	if array.size() == 0:
		return null
	var shuffled = array.duplicate()
	shuffled.shuffle()
	return shuffled[0]


func planet_bodies() -> Array:
	var bodies = [] # ugh, we really need to filter like this??? Godot 4.2 docs makes it look like 1/4 the code
	for planet in Global.planets:
		var body = planet.get_node("Body")
		if is_instance_valid(body):
			if body.global_position != origin.global_position:
				bodies.append(body)
	return bodies


func get_faction_color() -> String:
	return FACTION_COLORS[faction]


func _ready() -> void:
	if is_instance_valid(origin):
		position = origin.global_position
		position.x += int(rand_range(-1500.0, 1500.0))
		position.y += int(rand_range(-1500.0, 1500.0))
	
	name = random_array_choice(NPC_NAMES_POOL)
	add_to_group(FACTION_NAMES[faction])
	for faction_name in FACTION_NAMES:
		targets[faction_name] = [] # initalize 

	behavior = BEHAVIOR.traveling # start traveling
	if faction == FACTIONS.pirate:
		behavior = BEHAVIOR.pissed # make them upset at the world
	elif faction == FACTIONS.merchant: # MERCHANTS SETUP
		target = random_array_choice(planet_bodies())
	
	print("spawned: ", FACTION_NAMES[faction], ", ", name, " at ", position)


func _process(_delta):
	
	if not is_instance_valid(attack): # retarget if lost
		if faction == FACTIONS.pirate:
			for faction_name in ["player", "police", "merchant"]:
				if not targets[faction_name].empty():
					attack = targets[faction_name].pop_front()
		elif faction == FACTIONS.police:
			if not targets["pirate"].empty():
				attack = targets["pirate"].pop_front()
		# elif faction == FACTIONS.merchant:
		# 	for asteroid in asteroids:
		# 		if is_instance_valid(asteroid):
		# 			if position.distance_to(asteroid.global_position) < 250.0:
		# 				attack = asteroid
		
	
	if is_instance_valid(attack): # see if we need to attack first
		crosshairs = attack.global_position
		if not is_firing and position.distance_to(crosshairs) < 500.0:
			is_firing = true
			attack_target(1)
		elif is_firing:
			is_firing = false
	elif is_instance_valid(target):
		crosshairs = target.global_position
		if faction == FACTIONS.merchant:
			if position.distance_to(target.global_position) < 400.0:
				origin = target
				target = random_array_choice(planet_bodies())
		elif faction == FACTIONS.police:
			for faction_name in ["merchant", "player"]:
				if not targets[faction_name].empty():
					target = targets[faction_name].pop_front()
	

func _integrate_forces(_state):
	look_at(crosshairs)

	var speed = ship.speed

	if behavior != BEHAVIOR.chill: # chill = stay still
		var distance = position.distance_to(crosshairs)
		if distance < stopping:
			speed = 0.0
			linear_damp = -1
		elif distance < stopping * 2:
			speed = ship.speed
			linear_damp = 0.6
		else:
			speed = ship.speed / 2.0
			linear_damp = 0.15
	
	if is_instance_valid(attack) or is_instance_valid(target):
		thrust(speed)
	else:
		speed = ship.speed
		linear_damp = -1
		thrust(speed / 2.0)


func _draw():
	draw_colored_polygon(ship.points, FACTION_COLORS[faction])
	draw_polyline(ship.points, Color.white, ship.width, false)


func _on_Scanner_body_entered(body: Node):
	if body.is_in_group("asteroid"):
		asteroids.append(body)
	for faction_name in FACTION_NAMES:
		if body.is_in_group(faction_name):
			targets[faction_name].append(body) # add to the back


func _on_Scanner_body_exited(body: Node):
	if body.is_in_group("asteroid"):
		asteroids.erase(body)
	for faction_name in FACTION_NAMES:
		if body.is_in_group(faction_name):
			targets[faction_name].erase(body)
