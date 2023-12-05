extends MarginContainer

var player

func _ready():
	pass

func _physics_process(_delta):
	$List/Credits.text = "credits: %s" % Global.save.player.credits
	$List/Health/ProgressBar.value = player.ship.health
	$List/Fuel/ProgressBar.value = player.ship.fuel
	$List/Velocity.text = "velocity: %d" % player.linear_velocity.length()
	$List/FlightAssist.text = "flight assist: on" if player.flight_assist else "flight assist: off"
