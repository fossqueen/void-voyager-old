extends Node2D

func _ready():
	pass

func _physics_process(_delta):
	var player_system = Global.save.galaxy.galaxy[Global.save.player.current_system]
	var player_system_position = Vector2(player_system["Coordinates"]["X"], player_system["Coordinates"]["Y"])
	position.x = player_system_position.x * 10
	position.y = player_system_position.y * 10

func _draw():
	draw_polyline(PoolVector2Array([Vector2(-8, -8), Vector2(8, -8), Vector2(8, 8), Vector2(-8, 8), Vector2(-8, -8)]), Color.red, 1, false)
