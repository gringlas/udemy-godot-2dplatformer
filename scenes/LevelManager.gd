extends Node

export (Array, PackedScene) var levelScenes

var currentLevelIndex = 0
	
func change_level(levelIndex):
	currentLevelIndex = levelIndex
	if levelIndex >= levelScenes.size():
		$"/root/ScreenTransitionManager".transition_to_game_complete()
	else:
		$"/root/ScreenTransitionManager".transition_to_scene(levelScenes[currentLevelIndex].resource_path)

	
func increment_level():
	change_level(currentLevelIndex + 1)
