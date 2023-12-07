extends PanelContainer
var adj_pos: Vector2

func _ready():
	hide()

func _process(_delta):
	var screensize = OS.get_window_size()
	var cursor_pos = get_global_mouse_position()
	adj_pos.x = clamp(cursor_pos.x, 0, screensize.x - rect_size.x - 4) + 16
	adj_pos.y = clamp(cursor_pos.y, 0 , screensize.y - rect_size.y - 4)
	rect_position = adj_pos
