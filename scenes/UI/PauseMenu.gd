extends CanvasLayer

onready var continueButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
onready var optionsButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
onready var quitButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

var optionsMenuScene = preload("res://scenes/UI/OptionsMenu.tscn")

func _ready():
	continueButton.connect("pressed",self, "on_continue_pressed")
	optionsButton.connect("pressed",self, "on_options_pressed")
	quitButton.connect("pressed",self, "on_quit_pressed")
	get_tree().paused = true
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		unpause()
		get_tree().set_input_as_handled()
	
func unpause():
	get_tree().paused = false
	queue_free()
	

func on_continue_pressed():
	unpause()
	
	
func on_options_pressed():
	var optionsMenuInstance = optionsMenuScene.instance()
	add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	$MarginContainer.visible = false

func on_options_back_pressed():
	$OptionsMenu.queue_free()
	$MarginContainer.visible = true
	
func on_quit_pressed():
	$"/root/ScreenTransitionManager".transition_to_menu()
	unpause()
