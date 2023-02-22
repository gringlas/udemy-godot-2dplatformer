extends Node2D

var baseLevel = null

func _ready():
	$Area2D.connect("area_entered", self, "on_area_entered")
	$AnimationPlayer.play("idle")
	baseLevel = get_tree().get_nodes_in_group("base_level")[0]
	
func on_area_entered(area2d):
	if (area2d.is_in_group("Player")):
		$AnimationPlayer.play("pickup")
		call_deferred("disable_pickup")
		baseLevel.coin_collected()
		$RandomAudioStreamPlayer.play()
		$RandomAudioStreamPlayer2.play()
	
func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
