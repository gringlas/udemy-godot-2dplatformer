extends CanvasLayer

signal back_pressed

onready var windowedModeButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WindowedModeButton
onready var GameBoyShaderButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/GameBoyShaderButton
onready var backButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton
onready var musicRangeControl = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MusicVolumeContainer/RangeControl
onready var sfxRangeControl = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/SFXVolumeContainer/RangeControl


var isFullscreen = false
var isGameBoyShader = false

func _ready() -> void:
	windowedModeButton.connect("pressed", self, "on_window_mode_pressed")
	GameBoyShaderButton.connect("pressed", self, "on_game_boy_shader_pressed")
	backButton.connect("pressed", self, "on_back_pressed")
	musicRangeControl.connect("percentage_changed", self, "on_music_volume_changed")
	sfxRangeControl.connect("percentage_changed", self, "on_sfx_volume_changed")
	update_display()
	update_initial_volume_settings()


func update_display() -> void:
	windowedModeButton.text = "FULLSCREEN" if isFullscreen else "WINDOWED"
	GameBoyShaderButton.text = "GAMEBOY" if isGameBoyShader else "NORMAL"
	
	
func update_bus_volume(busName, volumePercent):
	var busIdx = AudioServer.get_bus_index(busName)
	var volumeDb = linear2db(volumePercent)
	AudioServer.set_bus_volume_db(busIdx, volumeDb)
	

func get_bus_volume_percent(busName) -> int:
	var busIdx = AudioServer.get_bus_index(busName)
	var volumePercent = db2linear(AudioServer.get_bus_volume_db(busIdx))
	return volumePercent


func update_initial_volume_settings():
	var musicPercent = get_bus_volume_percent("Music")
	musicRangeControl.set_current_percentage(musicPercent)
	var sfxPercent = get_bus_volume_percent("SFX")
	sfxRangeControl.set_current_percentage(sfxPercent)
	
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
	
	
func on_music_volume_changed(percent):
	update_bus_volume("Music", percent)
	
	
func on_sfx_volume_changed(percent):
	update_bus_volume("SFX", percent)
