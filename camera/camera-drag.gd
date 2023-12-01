extends Camera2D

export var zoom_min: float = 1.0
export var zoom_max: float = 2.0
export var zoom_factor: float = 1.0
export var zoom_duration: float = 0.2
onready var tween: Tween = $Tween
var _zoom_level: float = 2.0 setget _set_zoom_level
var mouse_start_pos
var screen_start_position
var dragging = false

# base functions
func _input(event):
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position

func _unhandled_input(_event):
	if Input.is_action_pressed("zoom_in"):
		_set_zoom_level(_zoom_level - zoom_factor)
	
	if Input.is_action_pressed("zoom_out"):
		_set_zoom_level(_zoom_level + zoom_factor)

# custom functions
func _set_zoom_level(value: float) -> void:
	_zoom_level = clamp(value, zoom_min, zoom_max)
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
		tween.TRANS_SINE,
		tween.EASE_OUT
	)
	tween.start()
