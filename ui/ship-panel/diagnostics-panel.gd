extends HBoxContainer

onready var player = Global.player

func _process(_delta):
	update_labels()
	pass

func update_labels():
	$DiagnosticsList/Health/ProgressBar.value = player.ship.health
	$DiagnosticsList/Fuel/ProgressBar.value = player.ship.fuel
	$DiagnosticsList/Shield/ProgressBar.value = player.ship.shield
	$DiagnosticsList/FlightAssist/Return.text = "Enabled" if player.flight_assist else "Disabled"
	$DiagnosticsList/FlightAssist/Return.add_color_override("font_color", Color(0, 1, 0) if player.flight_assist else Color(1, 0, 0))
	$DiagnosticsList/CurrentSystem/SystemName.text = Global.current_system["Name"]
	$DiagnosticsList/Credits/Amount.text = str(Global.save.player.credits)
