extends CanvasLayer

onready var quitButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	quitButton.connect("pressed", self, "on_quit_pressed")
	
func on_quit_pressed() -> void:
	$"/root/ScreenTransitionManager".transition_to_menu()
