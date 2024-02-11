extends Resource
class_name GalaxyGenerator

const OBJECT_MASS_MIN: float = 8.0
const OBJECT_MASS_MAX: float = 2048.0
const OBJECT_RADIUS_MIN: float = 128.0
const OBJECT_RADIUS_MAX: float = 512.0

const OBJECT_RINGS_CHANCE: int = 25 # % chance of planet spawning rings
const OBJECT_MOON_CHANCE: int = 25 # % chance of planet spawning moon(s)
const OBJECT_STATION_CHANCE: int = 50 # % chance of station spawning on objects

const OBJECT_DISTANCE_MIN:float = 4000.00
const OBJECT_DISTANCE_MAX:float = 12000.00

const STAR_MASS_MIN: float = 128.0
const STAR_MASS_MAX: float = 512.0

const ASTEROID_BELT_CHANCE: int = 5 # % chance of object being an asteroid belt
const MAX_ALLOWED_BELTS: int = 1 # maximum amount of asteroid belts per system, 1 is optimal for low-spec

const STATION_NAME_POOL: Array = ["Barker", "Atlas", "Springfield", "Alyx", "Apoapsis", "Periapsis", "Brendan", "Preston", "Light", "Blueshift", "Redshift", "Rousseau", "Locke", "Burke", "Argyle", "Devin"]
const STATION_SUFFIX_POOL: Array = ["Orbital", "Dock", "Station", "Terminal", "Port", "Outpost", "Installation", "Colony", "Reach"]


func random_string(length: int) -> String:
	var characters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var string: String = ""
	var n_char: int = len(characters)
	for _character in range(length):
		string += characters[randi()% n_char]
	return string


func random_digits(length: int) -> String:
	var digits: String = '1234567890'
	var string: String = ""
	var n_digi: int = len(digits)
	for _digit in range(length):
		string += digits[randi()% n_digi]
	return string


func generate_object(usable_mass: float, planet_name: String, distance: float) -> Dictionary:
	
	var mass: float = rand_range(OBJECT_MASS_MIN, OBJECT_MASS_MAX) # determines mass of object
	if mass > usable_mass:
		mass = usable_mass
	
	var radius: float = rand_range(OBJECT_RADIUS_MIN, OBJECT_RADIUS_MAX)
	
	var rings: bool = true if randi() % 100 + 1 <= OBJECT_RINGS_CHANCE else false
	
	var moons: bool = true if randi() % 100 + 1 <= OBJECT_MOON_CHANCE else false
	var moon_type: int = 1 # only 1 type for now, just future-proofing
	var moon_distance = radius * 10 # need to dial this, sometime gets really weird results
	
	var has_station: bool = false
	if not rings:
		has_station = true if randi() % 100 + 1 <= OBJECT_STATION_CHANCE else false
	
	var type = "Black Hole" if mass > 1500.00 and radius < 136 else "Terrestrial" if mass > 256.00 else "Gas Giant"
	
	var random_sub_type = randi() % 100 + 1 
	var sub_type = "None"
	
	if type == "Terrestrial":
		sub_type = "Earth-like" if random_sub_type <= 5 else "Waterworld" if random_sub_type <= 30 else "Terren"
	
	if sub_type == "Earth-like" and distance >= 24000:
		sub_type = "Ice-Planet"
	
	if sub_type == "Waterworld" and distance >= 24000: 
		sub_type = "Ice-Planet"
		
	return {
		"Name": planet_name,
		"Mass": mass if mass < usable_mass else usable_mass,
		"Type": type,
		"SubType": sub_type,
		"Radius": radius,
		"Rings": rings,
		"Distance": distance,
		"Moons": moons,
		"MoonType": moon_type,
		"MoonDistance": moon_distance,
		"Station": generate_station(moon_distance) if has_station else {"Exists": false},
	}


func generate_station(moon_distance: float) -> Dictionary:
	
	return {
		"Exists": true, # keeps track of stations existance, could be useful for destroying systems in the future
		"Name": STATION_NAME_POOL[randi() % STATION_NAME_POOL.size()] + " " + STATION_SUFFIX_POOL[randi() % STATION_SUFFIX_POOL.size()],
		"Size": randi() % 2, # 3 sizes, small(0), medium(1), large(2)
		"Distance": moon_distance * 1.25, #hardcoded distance from planet
		"State": 0, # hardcoded 'normal' state
	}


func generate_asteroid_belt(distance: float) -> Dictionary:
	return {
		"Name": "Belt",
		"Distance": distance,
		"Type": "Belt",
	}


func generate_system(x: float, y: float, system_name: String) -> Dictionary:
	
	var usable_mass = rand_range(256.00, 4096.00) # total mass of the system
	var core_mass = rand_range(STAR_MASS_MIN, STAR_MASS_MAX) # star mass
	usable_mass -= core_mass # remove star's mass from usable
	
	var star = {"Mass": core_mass, "Radius": core_mass}
	
	var object_ids = []
	var objects = {}
	
	var previous_distance = 0
	var random_distance = 0
	var belts = 0
	
	while usable_mass  > 0: # create objects until usable mass is depleted
		random_distance = rand_range(OBJECT_DISTANCE_MIN, OBJECT_DISTANCE_MAX)
		random_distance += previous_distance # add previous distance to build out from the center
		previous_distance = random_distance
		
		var object_id = random_digits(4) # random 4 digit id for the object
		
		if !object_ids.has(object_id): # only creates object if its id is unique
			object_ids.append(object_id)
			
			if randi() % 100 + 1 <= ASTEROID_BELT_CHANCE: 
				if belts < MAX_ALLOWED_BELTS:
					objects[object_id] = generate_asteroid_belt(random_distance)
					belts += 1
				else:
					continue
			
			else:
				objects[object_id] = generate_object(usable_mass, object_id, random_distance)
				usable_mass -= objects[object_id]["Mass"] # removes object's mass from usable
	
	return {
		"Name": system_name,
		"Coordinates": {
			"X": x,
			"Y": y,
		},
		"Population": int(pow(clamp(core_mass / ((Vector2.ZERO.distance_to(Vector2(x, y)) + 1) / 15), 0, rand_range(500000, 1000000)), 3)),
		"Star": star,
		"Objects": objects,
	}


func random_spiral(diameter: float, phi: float) -> Array:
	var radius = rand_range(0, diameter / 2)
	var angle = rand_range(0, 2 * PI)
	return [angle, (radius / (1 - (phi * tan(phi)) * log(angle / phi)))]


func generate_galaxy(stars: int, diameter: float, sigma: float) -> Array:
	
	var system_coordinates = []
	var system_names = []
	var galaxy_gen = []
	
	for _star in range(stars):
		var anglerad = random_spiral(diameter, sigma)
		
		var x1 = int((cos(anglerad[0]) * anglerad[1]))
		var y1 = int((sin(anglerad[0]) * anglerad[1]))
		
		var offset_x = rand_range(PI - 0.2, PI + 0.2)
		var offset_y = rand_range(PI - 0.2, PI + 0.2)
		var x2 = int((cos(anglerad[0] + offset_x) * anglerad[1]))
		var y2 = int((sin(anglerad[0] + offset_y) * anglerad[1]))
		
		if !system_coordinates.has(Vector2(x1, y1)):
			system_coordinates.append(Vector2(x1, y1))
			
			var system_name = random_string(5)
			if !system_names.has(system_name): # unique system names
				system_names.append(system_name)
				galaxy_gen.append(generate_system(x1, y1, system_name))
		
		if !system_coordinates.has(Vector2(x2, y2)):
			system_coordinates.append(Vector2(x2, y2))
			
			var system_name = random_string(5)
			if !system_names.has(system_name):
				system_names.append(system_name)
				galaxy_gen.append(generate_system(x2, y2, system_name))
	
	return galaxy_gen


func initialize_galaxy(stars: int, diameter: float, sigma: float) -> Array:
	randomize()
	var new_galaxy = generate_galaxy(stars, diameter, sigma)
	return new_galaxy
