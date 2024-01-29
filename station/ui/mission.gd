extends VBoxContainer

var title: String
var reward: String

func _ready():
	$Details/Title.text = title
	$Details/Reward.text = reward
