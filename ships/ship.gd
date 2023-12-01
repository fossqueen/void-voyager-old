extends Resource
class_name Ship

export var name: String = "Ship"

export var health: int = 100
export var shield: int = 100
export var fuel: float = 100

export var mass: int = 25000
export var speed: int = 75000

var width: int = 1
var antialiased: bool = false
var color_white = Color(1.0, 1.0, 1.0)
var color_black = Color(0.0, 0.0, 0.0)
export var points: PoolVector2Array = PoolVector2Array([Vector2(28, 0), Vector2(-12, 16) , Vector2(20, 0), Vector2(-12, -16), Vector2(28, 0)])
