extends VBoxContainer

var item_scene = load("res://ui/ship-panel/inventory-item.tscn")

func _ready():
	for item_unique_id in Global.save.player.inventory.items:
		var new_item = item_scene.instance()
		add_child(new_item)
		new_item.set_labels(item_unique_id, Global.save.player.inventory.get_amount(item_unique_id))

