extends Node2D

func _ready():
	$Area2D.connect("area_entered", self, "on_area_entered")
	$AnimationPlayer.play("idle")
	
func on_area_entered(area2d):
	if (area2d.is_in_group("Player")):
		$AnimationPlayer.play("pickup")
		call_deferred("disable_pickup")
	
func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
