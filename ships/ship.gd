extends Resource
class_name Ship

signal ship_destroyed

export var name: String = "Ship"

enum SHIP_ROLES { multi, trader, combat, exploration }
export(SHIP_ROLES) var role = SHIP_ROLES.multi

export var max_health: float = 100 
export var max_shield: float = 100
export var max_fuel: float = 100

var health: float = max_health
var shield: float = max_shield
var fuel: float = max_fuel

export var mass: int = 25000
export var speed: int = 75000

var width: int = 1
var antialiased: bool = false
export var points: PoolVector2Array = PoolVector2Array([Vector2(-20, 0), Vector2(-12, -16) , Vector2(28, 0), Vector2(-12, 16), Vector2(-20, 0)])


func damage(amount: float) -> void:
	if shield > 0: # damage goes to shield before health
		shield -= amount
		if shield < 0:
			health = max(0, health - abs(shield))
	else:
		health = max(0, health - amount)
	
	if health <= 0:
		emit_signal("ship_destroyed")


func refuel() -> void:
	fuel = max_fuel


func repair() -> void:
	health = max_health
	shield = max_shield
