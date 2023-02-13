extends CanvasLayer

func _ready() -> void:
	$PanelContainer/MarginContainer/VBoxContainer/Button.connect("pressed", self, "on_button_pressed")

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("jump")):
		$"/root/LevelManager".increment_level()
	
func on_button_pressed():
	$"/root/LevelManager".increment_level()

