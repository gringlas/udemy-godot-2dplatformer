extends Node2D

func _ready() -> void:
	$Area2D.connect("area_entered", self, "on_area_entered")
	$AnimationPlayer.play("default")
	
func on_area_entered(area2d):
	if area2d.is_in_group("Player"):
		$AnimationPlayer.play("pickup")
		call_deferred("disable_pickup")
		$"/root/GameManager".alter_player_lives(1)

func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
