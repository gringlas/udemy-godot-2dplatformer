extends CanvasLayer

onready var playButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PlayButton
onready var optionsButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
onready var quitButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

var optionsMenuScene = preload("res://scenes/UI/OptionsMenu.tscn")


func _ready() -> void:
	playButton.connect("pressed", self, "on_play_pressed")
	optionsButton.connect("pressed", self, "on_options_pressed")
	quitButton.connect("pressed", self, "on_quit_pressed")
	
func on_play_pressed():
	$"/root/LevelManager".change_level(0)
	
func on_options_pressed():
	var optionsMenuInstance = optionsMenuScene.instance()
	add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	$MarginContainer.visible = false

func on_options_back_pressed():
	$OptionsMenu.queue_free()
	$MarginContainer.visible = true

func on_quit_pressed():
	get_tree().quit()
