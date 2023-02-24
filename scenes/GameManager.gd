extends Node

signal lives_changed

var playerLives : int = 3 setget ,get_player_lives

func _ready() -> void:
	pass
	
func alter_player_lives(change) -> void:
	playerLives = playerLives + change
	emit_signal("lives_changed")
	
func get_player_lives() -> int:
	return playerLives
