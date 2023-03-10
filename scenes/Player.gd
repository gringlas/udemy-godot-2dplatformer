extends KinematicBody2D

var playerDeathScene = preload("res://scenes/PlayerDeath.tscn")
var footstepParticles = preload("res://scenes/FootstepParticles.tscn")

signal died

enum State { NORMAL, DASHING, INPUT_DISABLED }
export (int, LAYERS_2D_PHYSICS) var dashHazardMask
export (bool) var isOneScreen = false

var gravity = 1000
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 140
var maxDashSpeed = 500
var minDashSpeed = 200
var horizontalAcceleration = 1500
var maxJump = 400
var jumpTerminationMultiplier = 4
var hasDoubleJump = false
var hasDash = false
var currentState = State.NORMAL
var isStateNew = true
var defaultHazardMask = 0
var isDying = false
var lives = 3

func _ready() -> void:
	$HazardArea.connect("area_entered", self, "on_hazard_area_entered")
	$AnimatedSprite.connect("frame_changed", self, "on_animated_sprite_frame_changed")
	defaultHazardMask = $HazardArea.collision_mask

func _process(delta) -> void:
	one_screen()
	if velocity.y > 3000.0:
		kill()
	
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dashing(delta)
		State.INPUT_DISABLED:
			process_input_disabled(delta)
	isStateNew = false
	
	
func one_screen() -> void:
	if isOneScreen:
		if position.x > get_viewport_rect().size.x:
			position.x = 0
		if position.x < 0:
			position.x = get_viewport_rect().size.x
		
		
func change_state(newState) -> void:
	currentState = newState
	isStateNew = true
	
func process_normal(delta) -> void:
	if (isStateNew):
		$DashParticles.emitting = false
		$DashArea/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = defaultHazardMask
		
	var moveVector = get_movement_vector()
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if (moveVector.x == 0):
		#velocity.x = lerp(velocity.x, 0, .1)
		velocity.x = lerp(0, velocity.x, pow(2, -40 * delta))
		
	velocity.x = clamp(velocity.x, - maxHorizontalSpeed, maxHorizontalSpeed)
	
	# only jump when on floor, no flying by pressing again
	if (moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJump)):
		velocity.y = moveVector.y * maxJump
		
		if (!is_on_floor() && $CoyoteTimer.is_stopped()):
			$"/root/Helpers".apply_camera_shake(1)
			hasDoubleJump = false
			
		$CoyoteTimer.stop()
	
	# jump longer presssing makes you jump higher 
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
	
	var wasOnFloor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if (wasOnFloor && !is_on_floor()):
		$CoyoteTimer.start()
	if !wasOnFloor and is_on_floor() and !isStateNew:
		spawn_footsteps(1.5)
	
	if (is_on_floor()):
		hasDoubleJump = true
		hasDash = true
	
	if (hasDash && Input.is_action_just_pressed("dash")):
		$"/root/Helpers".apply_camera_shake(1)
		call_deferred("change_state", State.DASHING)
		hasDash = false
	
	update_animation()

func process_dashing(delta) -> void:
	if (isStateNew):
		$DashAudioPlayer.play()
		$DashParticles.emitting = true;
		$DashArea/CollisionShape2D.disabled = false
		$HazardArea.collision_mask = dashHazardMask
		$AnimatedSprite.play("jump")
		var moveVector = get_movement_vector()
		var velocityMod = 1
		if (moveVector.x != 0):
			velocityMod = sign(moveVector.x)
		else:
			velocityMod = 1 if $AnimatedSprite.flip_h else -1
		velocity = Vector2(maxDashSpeed * velocityMod, 0)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))
	if (abs(velocity.x) < minDashSpeed):
		call_deferred("change_state", State.NORMAL)
	

func process_input_disabled(delta):
	$AnimatedSprite.animation = "idle"
	velocity.x = lerp(0, velocity.x, pow(2, -40 * delta))
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector;
	
func update_animation():
	var moveVector = get_movement_vector()
	
	if (!is_on_floor()):
		$AnimatedSprite.play("jump")
	elif (moveVector.x != 0):
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
	
	if (moveVector.x != 0):
		$AnimatedSprite.flip_h = true if moveVector.x > 0 else false

func kill():
	if (isDying):
		return
	
	isDying = true
	
	$"/root/GameManager".alter_player_lives(-1)
	if $"/root/GameManager".playerLives == 0:
		$"/root/ScreenTransitionManager".transition_to_game_over()
		
		
	var playerDeathInstance = playerDeathScene.instance()
	playerDeathInstance.velocity = velocity
	get_parent().add_child_below_node(self, playerDeathInstance)
	playerDeathInstance.global_position = global_position
	emit_signal("died")	


func spawn_footsteps(scale = 1):
	var footstep = footstepParticles.instance()
	get_parent().add_child(footstep)
	footstep.scale = Vector2.ONE * scale
	footstep.global_position = global_position
	$FootstepAudioPlayer.play()


func disable_player_input():
	change_state(State.INPUT_DISABLED)

func on_hazard_area_entered(area2d):
	$"/root/Helpers".apply_camera_shake(1)
	call_deferred("kill")
	
	
func on_animated_sprite_frame_changed():
	if $AnimatedSprite.animation == "run" and $AnimatedSprite.frame == 0:
		spawn_footsteps()
