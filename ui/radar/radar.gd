extends MarginContainer

var player
export var zoom = 10

onready var player_marker = $Panel/PlayerMarker
onready var ship_marker = load("res://ui/radar/player-marker.tscn")
onready var star_marker = load("res://ui/radar/star-marker.tscn")
onready var planet_marker = load("res://ui/radar/planet-marker.tscn")
onready var asteroid_marker = load("res://ui/radar/asteroid-marker.tscn")
onready var moon_marker = load("res://ui/radar/moon-marker.tscn")

onready var icons = {"star": star_marker, "planet": planet_marker, "asteroid": asteroid_marker, "moon": moon_marker, "npc": ship_marker}

var grid_scale
var markers = {}

func _ready():
	player_marker.position = $Panel.rect_size / 2
	grid_scale = $Panel.rect_size / (get_viewport_rect().size * zoom)
	get_objects()

func _process(_delta):
	player_marker.rotation = player.rotation
	
	for i in markers:
		var obj_pos = (i.global_position  - player.position) * grid_scale + $Panel.rect_size / 2
		if $Panel.get_rect().has_point(obj_pos + $Panel.rect_position):
			markers[i].scale = Vector2(1, 1)
		else:
			markers[i].scale = Vector2(0.40, 0.40)
		obj_pos = clamp_circle(obj_pos, 64)
		markers[i].position = obj_pos

# Custom functions
func get_objects():
	var map_objects = get_tree().get_nodes_in_group("radar_objects")
	
	for object in map_objects:
		var new_marker = icons[object.radar_icon].instance()
		if object.radar_icon == "planet":
			new_marker.color = object.self_modulate
		elif object.radar_icon == "star":
			new_marker.color = object.color
		elif object.radar_icon == "moon":
			new_marker.color = object.self_modulate
		else:
			continue
		$Panel.add_child(new_marker)
		new_marker.show()
		markers[object] = new_marker
		print("boop")
	print("UI: Radar: Retrieved system objects")

func add_object(object):
	var new_marker = icons[object.radar_icon].instance()
	if object.radar_icon == "planet":
		new_marker.color = object.self_modulate
	elif object.radar_icon == "asteroid":
		new_marker.color = Color(1.0, 1.0, 1.0)
	elif object.radar_icon == "npc":
		new_marker.npc = true
		new_marker.node = object
		new_marker.color = object.FACTION_COLORS[object.faction]
	else:
		new_marker.color = object.color
	$Panel.add_child(new_marker)
	new_marker.show()
	markers[object] = new_marker

func remove_object(object):
	if object in markers:
		markers[object].queue_free()
		markers.erase(object)

func remove_all_objects():
	var map_markers = get_tree().get_nodes_in_group("radar_markers")
	for i in map_markers:
		$Panel.remove_child(i)
	markers = {}
	map_markers = {}
	print("UI: Radar: All objects removed")

func clamp_circle(obj_pos: Vector2, radius):
	var obj_dir = obj_pos - ($Panel.rect_size / 2)
	if obj_dir.length() > radius:
		obj_dir = radius * obj_dir.normalized()
	var clamped_pos = ($Panel.rect_size / 2) + obj_dir
	return clamped_pos
