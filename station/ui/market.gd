extends HBoxContainer

onready var commodities_list = $Scroll/Commodities

func _ready():
	for item in Items.DATABASE:
		var new_button = Button.new()
		new_button.text = Items.DATABASE[item]["Name"]
		new_button.size_flags_horizontal = 0
		commodities_list.add_child(new_button)
