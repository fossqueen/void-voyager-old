extends MarginContainer


onready var credits = $"%Credits"
onready var fuel_bar = $"%FuelBar"
onready var health_bar = $"%HealthBar"
onready var shield_bar = $"%ShieldBar"
onready var velocity = $"%Velocity"
onready var flight_assist = $"%FlightAssist"

var player


func _process(_delta):
	credits.text = "credits: %s" % Global.save.player.credits
	health_bar.value = player.ship.health
	shield_bar.value = player.ship.shield
	fuel_bar.value = player.ship.fuel
	velocity.text = "velocity: %d" % player.linear_velocity.length()
	flight_assist.text = "flight assist: on" if player.flight_assist else "flight assist: off"
