extends HBoxContainer

func _ready() -> void:
	$"/root/GameManager".connect("lives_changed", self, "on_lives_changed")
	update_display()

func update_display():
	$LivesLabel.set_text(str($"/root/GameManager".get_player_lives()))


func on_lives_changed():
	update_display()
