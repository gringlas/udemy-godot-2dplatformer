extends Node

export (String,
	"LevelMusic1",
	"LevelMusic2",
	"TitleMusic"	) var title = "LevelMusic1"

func _ready():
	play(title)

func play(track):
	for musicAudioPlayer in get_children():
		if musicAudioPlayer.name == track:
			musicAudioPlayer.play()
