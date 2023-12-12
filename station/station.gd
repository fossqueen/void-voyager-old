extends Node2D

const STATION_NAME_POOL: Array = ["Barker", "Atlas", "Springfield", "Alyx", "Apoapsis", "Periapsis", "Brendan", "Preston"]
const STATION_SUFFIX_POOL: Array = ["Orbital", "Dock", "Station", "Terminal", "Port", "Outpost", "Installation", "Colony"]
const STATION_MAX_HEALTH: int = 1000
const RADAR_ICON: String = "station"

enum STATE { normal, construction, emergency, repair }
enum REPUTATION { hostile, disliked, neutral, liked, admired }
enum SIZE { small, medium, large } # will influence commodity quantites and mission types
enum MISSION_TYPES { bounty, courier, passenger, source, explore }

var station_name: String
var station_health: float
export(SIZE) var station_size: int = SIZE.small
export(STATE) var station_state: int = STATE.normal


func generate_mission(): # will generate missions based on a number of variables
	pass
