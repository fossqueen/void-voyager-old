extends HBoxContainer

func set_labels(id, quantity):
	$Id.text = Items.DATABASE[id]["Name"]
	$Quantity.text = "x " + str(quantity)
