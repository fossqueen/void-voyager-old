extends Node2D

var damage: int = 1000

var parent
onready var laser = load("res://ships/modules/pulse-laser/laser.tscn")


func fire() -> void:
	var new_laser = laser.instance()
	new_laser.rotation = global_rotation
	new_laser.position = global_position
	new_laser.damage = damage
	new_laser.parent = parent
	Global.main.add_child(new_laser)
