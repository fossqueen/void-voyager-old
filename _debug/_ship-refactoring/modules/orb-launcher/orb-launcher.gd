extends Node2D


export var damage: int = 10
export var interval: float = 0.1

onready var orb = load("res://_debug/_ship-refactoring/modules/orb-launcher/orb.tscn")
onready var timer = $Interval

var is_firing: bool = false


func _ready():
	timer.wait_time = interval


func _unhandled_input(event):
	if event.is_action("secondary_fire"):
		var fire = event.is_pressed()
		is_firing = fire


func _process(_delta):
	if is_firing and timer.is_stopped():
		fire()
		timer.start()


func fire():
	var new_orb = orb.instance()
	
	new_orb.global_position = global_position
	
	new_orb.linear_velocity = get_parent().linear_velocity
	
	Global.main.add_child(new_orb)
