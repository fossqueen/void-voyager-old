extends CanvasLayer

var system
var adj_pos
var screensize
var max_distance

func _ready():
	$Camera2D.current = true
	set_labels()
	
func set_labels():
	$SystemDetails/List/SystemName.text = "system name: " + system["Name"]
	$SystemDetails/List/SystemDetails/SystemObjects.text = "points of interest: " + str(system["Objects"].size()) + ","
	$SystemDetails/List/SystemDetails/SystemPosition.text = "position in galaxy: " + str(system["Coordinates"])
