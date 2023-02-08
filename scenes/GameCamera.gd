extends Camera2D

var target_position = Vector2.ZERO

export (Color, RGB) var background_color
export (OpenSimplexNoise) var shakeNoise

var xNoiseSampleVector = Vector2.RIGHT
var yNoiseSampleVector = Vector2.DOWN
var xNoiseSamplePosition = Vector2.ZERO
var yNoiseSamplePosition = Vector2.ZERO
var noiseSampleTravelRate = 500
var maxShakeOffset = 8
var currentShakePercentage = 0
var shakeDecay = 4

func _ready() -> void:
	VisualServer.set_default_clear_color(background_color)

func _process(delta: float) -> void:
	aquire_target_position()
	var power = pow(2, -25 * delta)
	global_position = lerp(target_position, global_position, power)
	
	if (currentShakePercentage > 0):
		xNoiseSamplePosition += xNoiseSampleVector * noiseSampleTravelRate * delta
		yNoiseSamplePosition += yNoiseSampleVector * noiseSampleTravelRate * delta
		var xSample = shakeNoise.get_noise_2d(xNoiseSamplePosition.x, xNoiseSamplePosition.y)
		var ySample = shakeNoise.get_noise_2d(xNoiseSamplePosition.x, xNoiseSamplePosition.y)
		
		var calculatedOffset = Vector2(xSample, ySample) * maxShakeOffset * currentShakePercentage
		offset = calculatedOffset	
		
		currentShakePercentage = clamp(currentShakePercentage - shakeDecay * delta, 0, 1)
			
func aquire_target_position():
	var aquired = is_get_target_position_from_node_name("player")
	if (!aquired):
		is_get_target_position_from_node_name("player_death")

func is_get_target_position_from_node_name(groupName):
	var nodes = get_tree().get_nodes_in_group(groupName)
	if (nodes.size() > 0):
		var node = nodes[0]
		target_position = node.global_position
		return true
	return false
	

func apply_shake(percentage):
	currentShakePercentage = clamp(currentShakePercentage + percentage, 0, 1)
	 
