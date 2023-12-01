extends Resource
class_name GalaxyGenerator

var galaxy = []

func random_string(length):
	var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	var string: String = ""
	var n_char = len(characters)
	for _character in range(length):
		string += characters[randi()% n_char]
	return string

func random_digits(length):
	var digits = '1234567890'
	var string: String = ""
	var n_digi = len(digits)
	for _digit in range(length):
		string += digits[randi()% n_digi]
	return string

func into_2d(i, width):
	var a = (i % int(width))
	var b = (i / int(width))
	var c = Vector2(int(a), int(b))
	
	return c

func generate_object(usable_mass, planet_name, distance):
	var mass = rand_range(8.00, 2048.00)
	var radius = rand_range(128.00, 512.00)
	var rings: bool
	var moons: bool
	var moon_type: int = 1
	var moon_distance = rand_range(1500, 2500)
	var body_distance = distance
	var type = "Terrestrial" if mass > 256.00 else "Black Hole" if mass > 2000.00 and radius < 128.00 else "Gas Giant"
	var random_sub_type = int(rand_range(0, 100))
	var sub_type = "None"
	if type == "Terrestrial":
		sub_type = "Earth-like" if random_sub_type <= 5 else "Waterworld" if random_sub_type <= 30 else "Terren"
	if sub_type == "Waterworld" and distance >= 12000:
		sub_type = "Ice-Planet"
	if int(rand_range(0, 100)) <= 25:
		rings = true 
	else:
		rings = false
	if int(rand_range(0, 100)) <= 25:
		moons = true
	else:
		moons = false
	return {
		"Name": planet_name,
		"Mass": mass if mass < usable_mass else usable_mass,
		"Type": type,
		"SubType": sub_type,
		"Radius": radius,
		"Rings": rings,
		"Distance": body_distance,
		"Moons": moons,
		"MoonType": moon_type,
		"MoonDistance": moon_distance,
	}

func generate_asteroid_belt(distance):
	return {
		"Name": "Belt",
		"Distance": distance
	}

func generate_system(x, y, system_name):
	var usable_mass = rand_range(256.00, 4096.00)
	var core_mass = rand_range(128.00, 512.00)
	var star = {"Mass": core_mass, "Radius": core_mass}
	usable_mass -= core_mass
	var object_ids = []
	var objects = {}
	var min_distance = 6000
	var max_distance = 8000
	var previous_distance = 0
	var random_distance
	while usable_mass  > 0: 
		random_distance = rand_range(min_distance, max_distance)
		random_distance += previous_distance
		previous_distance = random_distance
		var object_id = random_digits(4)
		if !object_ids.has(object_id):
			object_ids.append(object_id)
			if int(rand_range(0, 100)) <= 5:
				objects[object_id] = generate_asteroid_belt(random_distance)
			else:
				objects[object_id] = generate_object(usable_mass, object_id, random_distance)
				usable_mass -= objects[object_id]["Mass"]
	return {
		"Name": system_name,
		"Coordinates": {
			"X": x,
			"Y": y,
		},
		"Star": star,
		"Objects": objects,
	}

func random_spiral(diameter, phi):
	var radius = rand_range(0, diameter / 2)
	var angle = rand_range(0, 2 * PI)
	return [angle, (radius / (1 - (phi * tan(phi)) * log(angle / phi)))]

func generate_galaxy(stars, diameter, sigma):
	var system_coordinates = []
	var system_names = []
	var galaxy_gen = []
	
	for _i in range(stars):
		var anglerad = random_spiral(diameter, sigma)
		
		var x1 = (cos(anglerad[0]) * anglerad[1])
		var y1 = (sin(anglerad[0]) * anglerad[1])
		
		var offset_x = rand_range(PI - 0.2, PI + 0.2)
		var offset_y = rand_range(PI - 0.2, PI + 0.2)
		var x2 = (cos(anglerad[0] + offset_x) * anglerad[1])
		var y2 = (sin(anglerad[0] + offset_y) * anglerad[1])
		
		if !system_coordinates.has(Vector2(x1, y1)):
			system_coordinates.append(Vector2(x1, y1))
			var system_name = random_string(5)
			if !system_names.has(system_name):
				system_names.append(system_name)
				galaxy_gen.append(generate_system(x1, y1, system_name))
		
		if !system_coordinates.has(Vector2(int(x2), int(y2))):
			system_coordinates.append(Vector2(x2, y2))
			var system_name = random_string(5)
			if !system_names.has(system_name):
				system_names.append(system_name)
				galaxy_gen.append(generate_system(x2, y2, system_name))
	return galaxy_gen

func initialize_galaxy(stars, diameter, sigma):
	randomize()
	var new_galaxy = generate_galaxy(stars, diameter, sigma)
	galaxy = new_galaxy
	return galaxy
