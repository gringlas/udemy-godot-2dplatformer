extends Camera2D

var target_position = Vector2.ZERO

var cameraPositionX : int
var cameraPositionY : int

export (Color, RGB) var background_color;

func _ready() -> void:
	VisualServer.set_default_clear_color(background_color)

func _process(delta: float) -> void:
	aquire_target_position()
	#var power = pow(2, -25 * delta)
	
	cameraPositionX = int(lerp(target_position.x, global_position.x, pow(2, -15 * delta)))
	cameraPositionY = int(lerp(target_position.y, global_position.y, pow(2, -15 * delta)))
	global_position = Vector2(cameraPositionX,cameraPositionY)

	
	#global_position = lerp(target_position, global_position, power)
	
func aquire_target_position():
	var players = get_tree().get_nodes_in_group("player")
	if (players.size() > 0):
		var player = players[0]
		global_position = player.global_position
