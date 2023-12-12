extends RigidBody2D
const radar_icon: String = "npc"

# maps to the enum values below
const NPC_NAMES_POOL = [ "lisa", "bart", "maggie", "homer", "marge", "millhouse", "martin", "ralph", "burns", "smithers", "barney", "grampa", "flanders", "wiggum", "lovejoy", "willie", "apu", "bob", "skinner", "krabappel", "krusty", "nelson", "quimby", "brockman", "riviera", "otto", "patty", "selma", "frink" ]
const FACTION_COLORS = [ Color.red, Color.blue, Color.green, Color.orange ]
const FACTION_NAMES = [ "pirate", "police", "merchant", "Lonely" ]

# enums are a good way to manage state, as a bonus they also show up in the template
enum FACTIONS { pirate, police, merchant, lonely }
enum BEHAVIOR { pissed, chill, scared, traveling }

onready var crosshairs: Vector2 # where the ship is pointing 
onready var stopping: float = 500.0 # stop 500m away by default
onready var ship: Ship = Ship.new() # ship resource

export (BEHAVIOR) var behavior = BEHAVIOR.chill # controls behavior (based on factions)
export (FACTIONS) var faction = FACTIONS.lonely # NPCs faction
export (Resource) var origin # resource to spawn from
export (Resource) var target # resource to move towards
export (bool) var attack: bool = false


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


# TODO: I want to put some of these in a util class somewhere at somepoint
func random_array_choice(array: Array): # any
	if array.empty():
		return null
	return array[randi() % array.size()]


func get_faction_color() -> String:
	return FACTION_COLORS[faction]


func _ready() -> void:
	if is_instance_valid(origin):
		position = origin.global_position
	
	name = random_array_choice(NPC_NAMES_POOL)
	add_to_group(FACTION_NAMES[faction])

	if faction == FACTIONS.pirate or faction == FACTIONS.police:
		behavior = BEHAVIOR.pissed # make them upset at the world
	elif faction == FACTIONS.merchant: # MERCHANTS SETUP
		# pick a planet and fly there
		var bodies = [] # ugh, we really need to filter like this??? Godot 4.2 docs makes it look like 1/4 the code
		var planets = Global.planets.duplicate()
		for planet in planets:
			var node = planet.get_node("Body")
			if node != target:
				bodies.append(node)

		bodies.shuffle()
		target = bodies[0]
	
	print_debug("spawned: ", FACTION_NAMES[faction], ", ", name, " at ", position)


func _process(_delta):
	$MiningLaser.set_is_casting(attack)
	if is_instance_valid(target):
		crosshairs = target.global_position
	else:
		if attack and behavior == BEHAVIOR.pissed:
			behavior = BEHAVIOR.chill
			attack = false

func _integrate_forces(_state):
	look_at(crosshairs)

	if behavior != BEHAVIOR.chill: # chill = stay still
		var speed = 0.0
		var distance = position.distance_to(crosshairs)
		if distance < stopping:
			if behavior == BEHAVIOR.pissed and not attack:
				attack = true
		elif distance < stopping * 2:
			speed = ship.speed / 1.2
			linear_damp = 0.6
		else:
			speed = ship.speed / 2.0
			linear_damp = 0.3
			if behavior == BEHAVIOR.pissed and attack:
				attack = false

		thrust(speed)


func _draw():
	draw_colored_polygon(ship.points, FACTION_COLORS[faction])
	draw_polyline(ship.points, Color.white, ship.width, false)


func _on_Scanner_body_entered(body):
	if faction == FACTIONS.pirate: # PIRATES
		# target player no matter what; if we are already targeting player, target anything but a pirate
		if body.is_in_group("player"):
			target = body
		elif is_instance_valid(target):
			if not (target.is_in_group("player") or body.is_in_group("pirate")): 
				target = body
	if faction == FACTIONS.police: # POLICE
		if body.is_in_group("pirate"):
			behavior = BEHAVIOR.pissed
			target = body
