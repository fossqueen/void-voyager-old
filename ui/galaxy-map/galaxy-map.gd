extends CanvasLayer

onready var system_plot = load("res://ui/galaxy-map/system-plot.tscn")
var data

func _ready():
	data = Global.save
	for i in data.galaxy.galaxy:
		var new_system_plot = system_plot.instance()
		new_system_plot.position.x = i["Coordinates"]["X"] * 4
		new_system_plot.position.y = i["Coordinates"]["Y"] * 4
		new_system_plot.position *= 10
		new_system_plot.system = i
		if i["Star"]["Mass"] > 500:
			new_system_plot.type = 6
		elif i["Star"]["Mass"] > 450:
			new_system_plot.type = 5
		elif i["Star"]["Mass"] > 400:
			new_system_plot.type = 4
		elif i["Star"]["Mass"] > 350:
			new_system_plot.type = 3
		elif i["Star"]["Mass"] > 300:
			new_system_plot.type = 2
		elif i["Star"]["Mass"] > 250:
			new_system_plot.type = 1
		else:
			new_system_plot.type = 0
		$VPC/Viewport.add_child(new_system_plot)
		$VPC/Viewport/Camera2D.position = $VPC/Viewport/MapMarker.position
		$VPC/Viewport/Camera2D.current = true
