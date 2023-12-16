extends HBoxContainer

func set_labels(id, quantity):
	$Id.text = id
	$Quantity.text = "x " + str(quantity)
