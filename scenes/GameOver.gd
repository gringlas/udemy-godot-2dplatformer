extends CanvasLayer

onready var playButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PlayButton
onready var mainMenuButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MainMenuButton

func _ready() -> void:
	playButton.connect("pressed", self, "on_play_pressed")
	mainMenuButton.connect("pressed", self, "on_main_menu_pressed")
	
func on_play_pressed():
	$"/root/LevelManager".change_level(0)

func on_main_menu_pressed():
	$"/root/ScreenTransitionManager".transition_to_menu()
