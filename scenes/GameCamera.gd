extends Camera2D

var target_position = Vector2.ZERO

export (Color, RGB) var background_color;

func _ready() -> void:
	VisualServer.set_default_clear_color(background_color)

func _process(delta: float) -> void:
	aquire_target_position()
	
	global_position = lerp(target_position, global_position, pow(2, -25 * delta))
	
func aquire_target_position():
	var players = get_tree().get_nodes_in_group("player")
	if (players.size() > 0):
		var player = players[0]
		global_position = player.global_position
