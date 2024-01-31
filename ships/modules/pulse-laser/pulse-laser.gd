extends Node2D

var damage: int = 125

onready var parent = get_parent()
onready var laser = load("res://ships/modules/pulse-laser/laser.tscn")
var is_firing:= false setget set_is_firing

func set_is_firing(fire: bool) -> void:
	is_firing = fire

func fire() -> void:
	var new_laser = laser.instance()
	new_laser.rotation = global_rotation
	new_laser.position = global_position
	new_laser.damage = damage
	new_laser.parent = parent
	Global.main.add_child(new_laser)

func _physics_process(_delta):
	if is_firing and $FireDelay.is_stopped():
		fire()
		$FireDelay.start()
