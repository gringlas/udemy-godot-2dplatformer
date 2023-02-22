extends CanvasLayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass
	

func _process(_delta: float) -> void:
	$CursorSprite.global_position = $CursorSprite.get_global_mouse_position()
	if Input.is_action_pressed("click"):
		$AnimationPlayer.play("click")
	
	
