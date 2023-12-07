extends CanvasLayer

var player = Global.player

var diagnostics_panel
var inventory_panel
var controls_panel

func _ready():
	player.set_process_input(false)
	diagnostics_panel = $Margin/Content/DiagnosticsPanel
	inventory_panel = $Margin/Content/InventoryList
	controls_panel = $Margin/Content/ControlsPanel
	diagnostics_panel.show()

func _on_CloseButton_pressed():
	player.set_process_input(true)
	Global.ui.close_ship_panel()

func _on_DiagnosticsButton_pressed():
	inventory_panel.hide()
	controls_panel.hide()
	diagnostics_panel.show()

func _on_InventoryButton_pressed():
	diagnostics_panel.hide()
	controls_panel.hide()
	inventory_panel.show()

func _on_ControlsButton_pressed():
	inventory_panel.hide()
	diagnostics_panel.hide()
	controls_panel.show()
