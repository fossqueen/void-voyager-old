class_name PlotRoute
extends Node2D


var _astar := AStar2D.new()
onready var galaxy: Array = Global.save.galaxy.galaxy

var jump_range: int = 30
onready var current_system = Vector2(Global.save.galaxy.galaxy[Global.save.player.current_system]["Coordinates"]["X"], Global.save.galaxy.galaxy[Global.save.player.current_system]["Coordinates"]["Y"])
var cell_mappings: Dictionary = {}
var directions = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0), Vector2(1, 1), Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1)]
onready var route = load("res://ui/galaxy-map/route.tscn")

func _init() -> void:
	pass


func _into_2d(i, width) -> Vector2:
	var a = (i % int(width))
	var b = (i / int(width))
	var c = Vector2(int(a), int(b))
	return c


func _add_and_connect_points(cell_mappings: Dictionary) -> void:
	for point in cell_mappings:
		_astar.add_point(cell_mappings[point], point)
		
	
	for point in cell_mappings:
		for neighbor in _find_neighbors(point, cell_mappings):
			_astar.connect_points(cell_mappings[point], neighbor) 

func _find_neighbors(cell: Vector2, cell_mappings: Dictionary) -> Array:
	var output: Array = []
	
	var grid_size = jump_range * jump_range
	var width = sqrt(grid_size)
	
	for i in range(grid_size):
		var neighbor = cell + _into_2d(i, width)
		
		if cell_mappings.has(neighbor):
			if neighbor.distance_to(cell) <= jump_range:
				if not neighbor == cell:
					if not _astar.are_points_connected(cell_mappings[cell], cell_mappings[neighbor]):
						 output.push_back(cell_mappings[neighbor])
	
	return output


func calculate_point_path(start: Vector2, end: Vector2) -> PoolVector2Array:
	
	if _astar.has_point(cell_mappings[start]) and _astar.has_point(cell_mappings[end]):
		
		var old_routes = get_tree().get_nodes_in_group("route")
		for old_route in old_routes:
			old_route.queue_free()
		
		var new_route = route.instance()
		new_route.points = _astar.get_point_path(cell_mappings[start], cell_mappings[end])
		print("Galaxy Map: New route created @ %s" % new_route.points)
		add_child(new_route)
		if new_route.points == PoolVector2Array():
			print("Galaxy Map: Route could not be plotted. Insufficient jump range.")
		
		return _astar.get_point_path(cell_mappings[start], cell_mappings[end])
	
	else:
		print("Galaxy Map: Error! Attempting to route to a non-existant star system.")
		return PoolVector2Array()


func _ready():
	for system in galaxy:
		var system_coordinates: Vector2 = Vector2(system["Coordinates"]["X"], system["Coordinates"]["Y"])
		cell_mappings[system_coordinates] = galaxy.find(system)
	
	_add_and_connect_points(cell_mappings)
