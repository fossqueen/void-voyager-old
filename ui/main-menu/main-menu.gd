extends Node2D

const TITLE: String = Global.TITLE
const SUBTITLE: Array = [
	"Yes, it's really happening!",
	"Now with more asteroids!",
	"Blast off!",
	"Everyone's favorite game!",
	"Part of a balanced breakfast!"]
const VERSION: String = Global.VERSION
const COPYRIGHT: String = Global.COPYRIGHT

var save_exists: bool = false
onready var main = get_parent()

# base functions
func _ready():
	randomize()
	set_labels()
	$UI/List/Buttons/NewGame.grab_focus()

func _physics_process(_delta):
	if save_exists:
		$UI/List/Buttons/LoadGame.disabled = false
	else:
		$UI/List/Buttons/LoadGame.disabled = true

# custom functions
func set_labels():
	$UI/List/Title.text = TITLE
	$UI/List/Subtitle.text = SUBTITLE[randi() % SUBTITLE.size()]
	$UI/Version.text = "version: " + VERSION
	$UI/Copyright.text = COPYRIGHT

# signals
func _on_NewGame_pressed():
	main.create_save()
	main.run_game()

func _on_LoadGame_pressed():
	main.run_game()

func _on_Settings_pressed():
	print("Settings")

func _on_Quit_pressed():
	get_tree().quit()
