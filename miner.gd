extends CharacterBody2D

@export var speed = 75

var stunned = false


func _process(delta):
	
	if stunned:
		return
	
	
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		input_vector.x += 1
		
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized() * speed
		move_and_collide(input_vector * delta)
		
		if input_vector.x != 0:
			$Sprite2D.flip_h = input_vector.x < 0


	var collision = move_and_collide(input_vector * delta)
	if collision:
		var block = collision.get_collider()
		block.hit()
		stunned = true
		
		var bounce_distance = -input_vector.normalized() * 20
		var t = create_tween()
		t.tween_property($Sprite2D, "position", bounce_distance, 0.2)
		t.tween_property($Sprite2D, "position", Vector2.ZERO, 0.2)
		
		await get_tree().create_timer(0.4).timeout
		stunned = false
		
	const GAME_BOUNDS = Rect2(Vector2.ZERO, Vector2(445, 375))
	position.x = clamp(position.x, GAME_BOUNDS.position.x + 15, GAME_BOUNDS.end.x)
	position.y = clamp(position.y, GAME_BOUNDS.position.y + 15, GAME_BOUNDS.end.y)
