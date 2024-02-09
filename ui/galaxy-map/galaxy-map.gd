extends CanvasLayer

onready var system_plot = load("res://ui/galaxy-map/system-plot.tscn")
var data
var selected_system
onready var camera = $VPC/Viewport/Camera2D
onready var selected_plot = $VPC/Viewport/SelectedPlot
onready var plot_route = $VPC/Viewport/PlotRoute
onready var player_system = Global.save.galaxy.galaxy[Global.save.player.current_system]
onready var player_system_position: Vector2  = Vector2(player_system["Coordinates"]["X"], player_system["Coordinates"]["Y"])

var plots = []

func _ready():
	data = Global.save
	for i in data.galaxy.galaxy:
		var new_system_plot = system_plot.instance()
		new_system_plot.position.x = i["Coordinates"]["X"] * 10
		new_system_plot.position.y = i["Coordinates"]["Y"] * 10
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
		new_system_plot.camera = camera
		new_system_plot.select = selected_plot
		new_system_plot.galaxy_map = self
		plots.append(new_system_plot)
		$VPC/Viewport.add_child(new_system_plot)
		$VPC/Viewport/Camera2D.position = $VPC/Viewport/MapMarker.position
		$VPC/Viewport/Camera2D.current = true

func _physics_process(_delta):
	$InfoBox/List/SelectedSystem/SystemName.text = selected_system["Name"] if selected_system else ""
	$InfoBox/List/SelectedDistance/Distance.text = str(int(player_system_position.distance_to(Vector2(selected_system["Coordinates"]["X"], selected_system["Coordinates"]["Y"])) * 2)) + " ly" if selected_system else ""
	
	$InfoBox/List/SelectedDistance/Distance.add_color_override("font_color", Color.green if selected_system and player_system_position.distance_to(Vector2(selected_system["Coordinates"]["X"], selected_system["Coordinates"]["Y"])) * 2 <= Global.player.jump_range else Color.red)
	
	$InfoBox/List/CurrentSystem/SystemName.text = Global.current_system["Name"]
	$InfoBox/List/CurrentDetails/Details.text = "Coordinates: " + str(int(player_system["Coordinates"]["X"])) + ", " + str(int(player_system["Coordinates"]["Y"])) + "\nPOI's: " + str(player_system["Objects"].size()) + "\nPopulation: " + str(player_system["Population"])
	$InfoBox/List/SelectedDetails/Details.text = "Coordinates: " + str(int(selected_system["Coordinates"]["X"])) + ", " + str(int(selected_system["Coordinates"]["Y"])) + "\nPOI's: " + str(selected_system["Objects"].size()) + "\nPopulation: " + str(selected_system["Population"]) if selected_system else ""
	player_system_position = Vector2(player_system["Coordinates"]["X"], player_system["Coordinates"]["Y"])
	player_system = Global.save.galaxy.galaxy[Global.save.player.current_system]
	$InfoBox/List/Fuel/ProgressBar.value = Global.player.ship.fuel

func scale_plots(value: float) -> void:
	var plots = get_tree().get_nodes_in_group("system_plot")
	for plot in plots:
		plot.scale = Vector2(value / 16, value / 16)
		$VPC/Viewport/MapMarker.scale = Vector2(value, value)
		selected_plot.scale = Vector2(value, value)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("hyperspace"):
		if selected_system:
			if player_system_position.distance_to(Vector2(selected_system["Coordinates"]["X"], selected_system["Coordinates"]["Y"])) * 2 <= Global.player.jump_range:
				if Global.player.ship.fuel > 0:
					Global.player.ship.fuel -= player_system_position.distance_to(Vector2(selected_system["Coordinates"]["X"], selected_system["Coordinates"]["Y"]))
					if Global.player.ship.fuel < 0:
						Global.player.ship.fuel = 0
					Global.main.hyperspace(data.galaxy.galaxy.find(selected_system, 0))
			else:
				print("Exceeded Jump Range")
				$MessageBox/VBox/Label.text = "Jump Range is insufficient."
				$MessageBox.show()
		else:
			print("No selected system")
			$MessageBox/VBox/Label.text = "No star system selected."
			$MessageBox.show()


func _on_CurrentSystem_pressed():
	$VPC/Viewport/Camera2D.position = player_system_position * 10
	print(player_system_position)


func _on_SelectedSystem_pressed():
	if selected_system:
		$VPC/Viewport/Camera2D.position = Vector2(selected_system["Coordinates"]["X"], selected_system["Coordinates"]["Y"]) * 10


func _on_Jump_pressed():
		if selected_system:
			if player_system_position.distance_to(Vector2(selected_system["Coordinates"]["X"], selected_system["Coordinates"]["Y"])) * 2 <= Global.player.jump_range:
				if Global.player.ship.fuel > 0:
					Global.player.ship.fuel -= player_system_position.distance_to(Vector2(selected_system["Coordinates"]["X"], selected_system["Coordinates"]["Y"]))
					if Global.player.ship.fuel < 0:
						Global.player.ship.fuel = 0
					Global.main.hyperspace(data.galaxy.galaxy.find(selected_system, 0))
			else:
				print("Exceeded Jump Range")
				$MessageBox/VBox/Label.text = "Jump Range is insufficient."
				$MessageBox.show()
		else:
			print("No selected system")
			$MessageBox/VBox/Label.text = "No star system selected."
			$MessageBox.show()


func _on_LineEdit_text_entered(new_text):
	for system in data.galaxy.galaxy:
		if system["Name"] == new_text:
			selected_system = system
			$VPC/Viewport/SelectedPlot.position = Vector2(selected_system["Coordinates"]["X"], selected_system["Coordinates"]["Y"]) * 10


func _on_Search_pressed():
	for system in data.galaxy.galaxy:
		if system["Name"] == $InfoBox/List/Search/LineEdit.text:
			selected_system = system
			$VPC/Viewport/SelectedPlot.position = Vector2(selected_system["Coordinates"]["X"], selected_system["Coordinates"]["Y"]) * 10


func _on_Plot_pressed():
	if selected_system:
		plot_route.calculate_point_path(player_system_position, Vector2(selected_system["Coordinates"]["X"], selected_system["Coordinates"]["Y"]))
