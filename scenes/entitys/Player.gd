extends "res://scenes/entitys/DefaultEntity.gd"

export (int) var acceleration = 200
export (int) var max_speed = 400
export (float) var inertia = 0.9

var velocity : Vector2 = Vector2(0, 0)


func _physics_process(delta: float) -> void:
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
	else:
		$AnimatedSprite.animation = "default"
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_shooting:
		$StandardWeapon.shoot()
#		$ShotgunWeapon.shoot()
#		$MGWeapon.shoot()
