extends Entity
class_name Player
signal hit(health)

export (int) var acceleration = 50
export (int) var max_speed = 300
export (float) var inertia = 0.9
export (int) var friendly_distance = 15
export (int) var friendly_amount = 0
var paused = false

var friendlies = []


func _add_friendly(friendly: Node) -> void:
	var position = friendly.global_position
	friendly.pick_uo()
	friendly.get_parent().remove_child(friendly)
	friendlies.append(friendly)
# warning-ignore:return_value_discarded
	friendly.connect("death", self, "_on_Friendly_death", [friendly])
	add_child(friendly)
	friendly.global_position = position
	_realign_friendlies()


func _realign_friendlies() -> void:
	var center = $CenterFriendlyLocation.position
	var left = $LeftFriendlyLocation.position
	
	var width = (len(friendlies) - 1) * friendly_distance
	var left_most = - width / 2
	var slope = left - center
	
	slope = slope.y / slope.x
	
	for index in len(friendlies):
		var friendly: KinematicBody2D = friendlies[index]
		friendly.target_position = center
		
		friendly.target_position.x = left_most + index * friendly_distance
		friendly.target_position.y = center.y - slope \
				* abs(friendly.target_position.x)


func _on_Friendly_death(friendly) -> void:
	friendlies.remove(friendlies.find(friendly))
	call_deferred("_realign_friendlies")


func _physics_process(_delta: float) -> void:
	if paused:
		return
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
		
	for friendly in friendlies:
		friendly.get_node("AnimatedSprite").animation = \
				$AnimatedSprite.animation
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	var viewport_size = get_viewport_rect().size \
			/ get_canvas_transform().get_scale()
	var half_viewport_size = viewport_size / 2
	var half_width = $CollisionShape2D.shape.height / 2
	var half_height = $CollisionShape2D.shape.height / 2 \
			+ $CollisionShape2D.shape.radius

	position.x = clamp(position.x, -half_viewport_size.x + half_width,
			half_viewport_size.x - half_width)

	position.y = clamp(position.y, -half_viewport_size.y + half_height,
			half_viewport_size.y - half_height)
	
	if position.x < -half_viewport_size.x:
		position.x += viewport_size.x
	elif position.x > half_viewport_size.x:
		position.x -= viewport_size.x
	
	if is_shooting:
		$StandardWeapon.shoot()
#		$ShotgunWeapon.shoot()
#		$MGWeapon.shoot()
		
		for friendly in friendlies:
			friendly.shoot()


func hit(damage):
	health -= damage
	emit_signal("hit", health)
	$AnimatedSprite.animation = "hit"
	$AnimatedSprite.play()
	if health <= 0:
		destroy()


func destroy():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.animation = "die"
	$AnimatedSprite.play()
	yield($AnimatedSprite, "animation_finished" )
	emit_signal("death")
	queue_free()


func set_paused(_paused):
	self.paused = _paused


func _on_Area2D_body_shape_entered(_body_id: int, body: Node, _body_shape: int, 
		_area_shape: int) -> void:
	if body.is_in_group("friendly") and not body.picked_up:
		call_deferred("_add_friendly", body)
