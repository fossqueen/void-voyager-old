extends Resource
class_name ShipClass

signal ship_destroyed

# Exported Constants
export var MODEL_NAME: String

export var MAX_HEALTH: float
export var MAX_SHIELD: float
export var MAX_FUEL: float
export var MAX_CARGO: float
export var THRUST_POWER: int

export var POINTS: PoolVector2Array # Coordinates for drawing the ship
export var POINTS_2: PoolVector2Array # Second set of coordinates, for more detail


# Variables
var player_given_name: String # To eventually allow naming of personal ships

var health: float
var shield: float
var fuel: float

var cargo: Array


func init_ship() -> void:
	repair()
	refuel()
	cargo = []


func damage(amount: float) -> void:
	if shield > 0: # Damage dealt to shield before health
		shield -= amount
		if shield < 0: # If damage is greater than shield amount, deal the rest to health
			health = max(0, health - abs(shield))
	else: # No shield to begin with
		health = max(0, health - amount)
	
	if health <= 0: # Check if destroyed
		emit_signal("ship_destroyed")


func refuel() -> void:
	fuel = MAX_FUEL


func repair() -> void:
	health = MAX_HEALTH
	shield = MAX_SHIELD
