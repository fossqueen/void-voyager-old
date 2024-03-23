extends Node2D


const PATTERNS: Array = [
	[0, 1, 0, 0, 1
	],
	[1, 0, 1, 0, 0
	],
	[1, 0, 0, 1, 0
	],
	[0, 0, 1, 0, 1
	],
	[1, 0, 1, 0, 1
	],
]


func random_letter(type: int) -> String:
	var characters: String
	if type == 0:
		characters = "AAAEEEIIOOUYAAAEEEIIOOUYAAAEEEIIOOUYAAAEEEIIOOUYAAAEEEIIOOUYW---"
	if type == 1:
		characters = "BBBCCCCCDFGGGHJKLMMMMMNNNNNPQQQQQRSSSSSTTTVWXXXXXYYYYYZZZZZ"
	var n_char = len(characters)
	var output = characters[randi() % n_char]
	
	return output


func random_name() -> String:
	var name: String
	
	var pattern = PATTERNS[randi() % PATTERNS.size()]
	
	var previous_letter
	
	for letter in pattern:
		var string = str(random_letter(letter))
		while string == previous_letter:
			var dice = randi() % 100 + 1
			if dice <=95:
				str(random_letter(letter))
			
			previous_letter = string
		
		name += string
	
	return name

func _ready():
	randomize()
	for i in range(100):
		print(random_name())
