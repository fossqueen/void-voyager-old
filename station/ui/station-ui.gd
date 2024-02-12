extends CanvasLayer

onready var mission_scene = load("res://station/ui/mission.tscn")

onready var available_missions_list = $Margin/Body/Missions/Available/Scroll/List
onready var station_name = $Margin/Body/Header/StationName

var available_missions = []

var refuel_cost
var repair_cost


func refresh_missions():
	for contract in available_missions:
		var new_mission = mission_scene.instance()
		new_mission.title = contract["Title"]
		new_mission.reward = str(contract["Reward"]) + " credits"
		available_missions_list.add_child(new_mission)


func refresh_player_stats() -> void:
	$Margin/Body/Services/Hangar/Repair/Health.value = Global.player.ship.health
	$Margin/Body/Services/Hangar/Refuel/Fuel.value = Global.player.ship.fuel
	
	refuel_cost = int(abs(100 - Global.player.ship.fuel) * Items.FUEL["Cost"])
	repair_cost = int(abs(100 - Global.player.ship.health) * 5)
	
	$Margin/Body/Services/Hangar/Refuel/Label.text = str(refuel_cost) + " credits"
	$Margin/Body/Services/Hangar/Repair/Label.text = str(repair_cost) + " credits"





func _on_Close_pressed():
	hide()
	Global.player.undock(get_parent().station.global_position, get_parent().camera)


func _on_RepairButton_pressed():
	if Global.save.player.credits >= repair_cost:
		Global.player.ship.health = 100 # hardcoded bc late night lol.
		refresh_player_stats()
	else:
		print("Station: Cannot repair, insufficient credits!")


func _on_RefuelButton_pressed():
	if Global.save.player.credits >= refuel_cost:
		Global.player.ship.fuel = 100 # hardcoded bc late night lol.
		refresh_player_stats()
	else:
		print("Station: Cannot refuel, insufficient credits!")
