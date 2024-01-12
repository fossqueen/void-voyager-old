tool
extends Area2D

export var itemID: int = 0

export var points: PoolVector2Array
var color: Color = Color.white


func _draw() -> void:
	draw_circle(Vector2.ZERO, 4, Color.black)
	draw_arc(Vector2.ZERO, 4, 0, deg2rad(360), 16, Color.white, 1, false)


func _on_Item_body_entered(body):
	if body.is_in_group("player"):
		Global.save.player.inventory.add_item(itemID, 1)
		queue_free()
