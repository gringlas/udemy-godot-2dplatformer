extends Node2D

var screenTransitionScene = preload("res://scenes/UI/ScreenTransition.tscn")

func transition_to_scene(scenePath):
	for button in get_tree().get_nodes_in_group("animated_button"):
		button.disabled = true
	
	yield(get_tree().create_timer(.2), "timeout")
	var screenTransition = screenTransitionScene.instance()
	add_child(screenTransition)
	yield(screenTransition, "screen_covered")
	get_tree().change_scene(scenePath)

func transition_to_menu():
	transition_to_scene("res://scenes/UI/MainMenu.tscn")

func transition_to_game_complete():
	transition_to_scene("res://scenes/UI/GameComplete.tscn")
	
func transition_to_game_over():
	transition_to_scene("res://scenes/GameOver.tscn")
