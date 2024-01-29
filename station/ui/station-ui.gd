extends CanvasLayer

onready var mission_scene = load("res://station/ui/mission.tscn")

onready var available_missions_list = $Margin/Body/Missions/Available/Scroll/List

var available_missions = []

func refresh_missions():
	for contract in available_missions:
		var new_mission = mission_scene.instance()
		new_mission.title = contract["Title"]
		new_mission.reward = str(contract["Reward"]) + " credits"
		available_missions_list.add_child(new_mission)
