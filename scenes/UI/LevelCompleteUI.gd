extends CanvasLayer

func _ready() -> void:
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/NextLevelButton.connect("pressed", self, "on_button_pressed")

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("jump")):
		$"/root/LevelManager".increment_level()
	
func on_button_pressed():
	$"/root/LevelManager".increment_level()

