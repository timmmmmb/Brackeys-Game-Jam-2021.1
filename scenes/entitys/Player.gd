extends "res://scenes/entitys/DefaultEntity.gd"

export (int) var acceleration = 50
export (int) var max_speed = 300
export (float) var inertia = 0.9


func _physics_process(_delta: float) -> void:
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")

	var is_shooting = Input.is_action_pressed("shoot")

	var direction = Vector2(0, 0)

	if left:
		direction.x -= 1
	if right:
		direction.x += 1
	if up:
		direction.y -= 1
	if down:
		direction.y += 1
	
	velocity += direction.normalized() * acceleration
	
	if not left and not right:
		velocity.x *= inertia
	
	if not up and not down:
		velocity.y *= inertia
		
	if left or right or up or down:
		$AnimatedSprite.animation = "flying"
		$AnimatedSpriteClone.animation = "flying"
	else:
		$AnimatedSprite.animation = "default"
		$AnimatedSpriteClone.animation = "flying"
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	var viewport_size = get_viewport_rect().size \
			/ get_canvas_transform().get_scale()
	var half_viewport_size = viewport_size / 2
	var half_height = $CollisionShape2D.shape.height / 2 \
			+ $CollisionShape2D.shape.radius
	
	position.y = clamp(position.y, -half_viewport_size.y + half_height,
			half_viewport_size.y - half_height)
	
	$AnimatedSpriteClone.global_position = position
	
	if position.x < -half_viewport_size.x:
		position.x += viewport_size.x
	elif position.x > half_viewport_size.x:
		position.x -= viewport_size.x
	
	if position.x < 0:
		$AnimatedSpriteClone.global_position.x += viewport_size.x
	else:
		$AnimatedSpriteClone.global_position.x -= viewport_size.x
	
	if is_shooting:
		$StandardWeapon.shoot()
#		$ShotgunWeapon.shoot()
#		$MGWeapon.shoot()
