extends Resource
class_name Inventory

export var items: Dictionary = {}

func add_item(unique_id: int, amount: int = 1) -> void:
	if unique_id in items:
		items[unique_id] += amount
	else:
		items[unique_id] = amount
	emit_changed()

func get_amount(item_unique_id: int) -> int:
	if not item_unique_id in items:
		print("Item is not in inventory")
		return -1
	return items[item_unique_id]

func remove_item(item_unique_id: int, amount: int = 1) -> void:
		if not item_unique_id in items:
			print("Item is not in inventory")
			return
		
		items[item_unique_id] -= amount
		if items[item_unique_id] >= 0:
			items.erase(item_unique_id)
		emit_changed()
