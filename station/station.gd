extends Node2D


const STATION_MAX_HEALTH: int = 1000

enum STATE { normal, construction, emergency, repair }
enum REPUTATION { hostile, disliked, neutral, liked, admired }
enum SIZE { small, medium, large } # will influence commodity quantites and mission types eventually
enum MISSION_TYPES { bounty, courier, passenger, source, explore }

var station_name: String = ""
var station_health: float
var station_distance: float

export(SIZE) var station_size: int = SIZE.small
export(STATE) var station_state: int = STATE.normal

onready var ui = $StationUI
onready var station = $Station
onready var camera = $Station/Camera

var available_missions: Array = []
var mouse_entered: bool = false


func generate_mission(): # will generate missions based on a number of variables
	randomize()
	var mission_type = randi() % MISSION_TYPES.size() # randomizes mission type
	#var mission_type = 0 # comment out, used to test specific mission types
	
	if mission_type == MISSION_TYPES.bounty:
		print("Station: Generating bounty mission...")
		
		var target_quantity = randi() % 10 # random quantity of bounties, could work reputation into this calculation
		
		var reward = target_quantity * 10000 # hardcoded 10k credits per bounty
		
		print("Mission: Destroy %s pirates. Reward: %s credits." % [target_quantity, reward])
		
		return{
			"Type": mission_type,
			"Title": "Destroy %s pirates." % target_quantity,
			"Faction": 0, # targets the pirate faction only, could change this for different station factions
			"Quantity": target_quantity,
			"Reward": reward,
		}
		
	if mission_type == MISSION_TYPES.courier:
		print("Station: Generating courier mission...")
		return{
			"Title": "Courier Job",
			"Reward": "0 credits",
		}
	
	if mission_type == MISSION_TYPES.passenger:
		print("Station: Generating passenger mission...")
		return{
			"Title": "Passenger Request",
			"Reward": "0 credits",
		}
	
	if mission_type == MISSION_TYPES.source:
		print("Station: Generating source mission...")
		
		var BASE_REWARD: int = 10
		
		var valid_items = [] # randomly selects target item based on allowed types
		for item in Items.DATABASE:
			if Items.DATABASE[item]["Type"] == Items.ITEM_TYPE.MINERAL: # for example, this function only selects mineral items
				valid_items.append(item)
		var target_item = valid_items[randi() % valid_items.size()]
		
		var target_quantity = randi() % 20 # randomly selects a quantity to source, hardcoded to 20 max temporarily
		
		var reward = BASE_REWARD * target_quantity * Items.DATABASE[target_item]["Cost"] # reward based on quantity and cost of item
		
		print("Mission: Source %s units of %s. Reward: %s credits." % [target_quantity , Items.DATABASE[target_item]["Name"], reward])
		
		return {
			"Type": mission_type,
			"Title": "Source %s units of %s." % [Items.DATABASE[target_item]["Name"], target_quantity],
			"Item": target_item,
			"Quantity": target_quantity,
			"Reward": reward,
		}
	
	if mission_type == MISSION_TYPES.explore:
		print("Station: Generating exploration mission...")
		return{
			"Title": "Exploration Contract",
			"Reward": "0 credits",
		}


func _ready():
	var count = 10
	while count > 0:
		var new_mission = generate_mission()
		available_missions.append(new_mission)
		count -= 1
	
	ui.available_missions = available_missions
	ui.refresh_missions()
	$Station.position.x = station_distance


func _physics_process(_delta):
	rotation += 0.00005


func _draw():
	draw_arc(Vector2.ZERO, station_distance, 0, deg2rad(360), 100, Color(1, 1, 1, 0.1))


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and mouse_entered and station.global_position.distance_to(Global.player.global_position) < 360:
		ui.show()
		Global.player.dock(self)


func _on_Station_mouse_entered():
	mouse_entered = true
	
	$UI/ToolTip/Label.text = station_name + "\nPress ENTER to dock."
	$UI/ToolTip.show()


func _on_Station_mouse_exited():
	mouse_entered = false
	
	$UI/ToolTip.hide()
	
