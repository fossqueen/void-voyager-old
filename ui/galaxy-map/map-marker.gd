extends Node2D

func _ready():
	var player_system = Global.save.galaxy.galaxy[Global.save.player.current_system]
	var player_system_position = Vector2(player_system["Coordinates"]["X"], player_system["Coordinates"]["Y"])
	
	position.x = player_system_position.x * 4
	position.y = player_system_position.y * 4
	position *= 10
