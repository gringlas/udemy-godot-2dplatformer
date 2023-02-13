extends KinematicBody2D

var EnemyDeathScene = preload("res://scenes/EnemyDeath.tscn")

export var isSpawning = true

var maxSpeed = 25
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500
var startDirection = Vector2.RIGHT

func _ready():
	direction = startDirection
	$GoalDetector.connect("area_entered", self, "on_goal_entered")
	$HitBoxArea.connect("area_entered", self, "on_hitbox_entered")

func _process(delta):
	if (isSpawning):
		return
	
	velocity.x = (direction * maxSpeed).x
	velocity.y += delta * gravity 
	velocity = move_and_slide(velocity, Vector2.UP)
	$Visuals/AnimatedSprite.flip_h = true if direction.x > 0 else false
	
func kill():
	var enemyDeathSceneInstance = EnemyDeathScene.instance()
	get_parent().add_child(enemyDeathSceneInstance)
	enemyDeathSceneInstance.global_position = global_position
	if (velocity.x > 0):
		enemyDeathSceneInstance.scale = Vector2(-1, 1)
	queue_free()
	
	
func on_goal_entered(_area2d):
	direction.x *= -1
	
# enemy dies
func on_hitbox_entered(_area2d):
	$"/root/Helpers".apply_camera_shake(1)
	call_deferred("kill")
