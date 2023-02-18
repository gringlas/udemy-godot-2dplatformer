extends CanvasLayer

signal back_pressed

onready var windowedModeButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WindowedModeButton
onready var GameBoyShaderButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/GameBoyShaderButton
onready var backButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton

var isFullscreen = false
var isGameBoyShader = false

func _ready() -> void:
	windowedModeButton.connect("pressed", self, "on_window_mode_pressed")
	GameBoyShaderButton.connect("pressed", self, "on_game_boy_shader_pressed")
	backButton.connect("pressed", self, "on_back_pressed")
	update_display()	

func update_display() -> void:
	windowedModeButton.text = "FULLSCREEN" if isFullscreen else "WINDOWED"
	GameBoyShaderButton.text = "GAMEBOY" if isGameBoyShader else "NORMAL"
	
	
func on_window_mode_pressed() -> void:
	isFullscreen = !isFullscreen
	OS.window_fullscreen = isFullscreen
	update_display()	
		
func on_game_boy_shader_pressed() -> void:
	isGameBoyShader = !isGameBoyShader
	$"/root/ShaderLayer".activate_game_boy_shader(isGameBoyShader)
	update_display()	
	
func on_back_pressed():
	emit_signal("back_pressed")
