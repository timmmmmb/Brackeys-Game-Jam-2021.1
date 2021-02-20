extends Enemy

var stage = 1
var spawn_frame = -1
var Drone: PackedScene  = preload("res://scenes/entities/Drone.tscn")

func spawn_drone():
	$AnimatedSprite.animation = "opengate"
	$AnimatedSprite.play()


func behaviour():
	if state == STATE.DEAD:
		return
	if patrol_path && state != STATE.IDLE:
		var target = patrol_points[patrol_index]
		if position.distance_to(target) < 1:
			patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
			target = patrol_points[patrol_index]
		velocity = (target - position).normalized() * speed
		velocity = move_and_slide(velocity)
	if state == STATE.ATTACKING:
		shoot()
		$AttackDelay.start(0)
		state = STATE.MOVING

func hit(damage):
	if state == STATE.DEAD || state == STATE.IDLE:
		return
	health -= damage
	if health <= 0:
		$"healthbar-boss-container".visible = false
		$"healthbar-boss-health".visible = false
		destroy()
	else:
		var current_stage = stage
		if health <= 80 && health > 60:
			stage = 1
		elif health <= 60 && health > 40:
			stage = 2
		elif health <= 40 && health > 20:
			stage = 3
		elif health <= 20 && health > 0:
			stage = 4
		if current_stage != stage:
			if stage == 2:
				spawn_drone()
				$DroneTimer.start(0)
			if stage == 3:
				$AttackDelay.stop()
				$RocketTimer.start(0)
			if stage == 4:
				$AttackDelay.start(0)
		if $AnimatedSprite.animation == "opengate" && $AnimatedSprite.frame < 3:
			spawn_frame = $AnimatedSprite.frame
		
		$"healthbar-boss-health".frame = ceil(float(health) / 8.0)
		$AnimatedSprite.animation = "hit"
		$AnimatedSprite.play()
		print(health)


func _on_RocketTimer_timeout() -> void:
	if state == STATE.DEAD:
		return
	$RocketWeapon.shoot()


func _on_DroneTimer_timeout() -> void:
	if state == STATE.DEAD:
		return
	spawn_drone()
	
func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "die":
		emit_signal("death")
		queue_free()
	elif $AnimatedSprite.animation == "hit" :
		if spawn_frame != -1:
			$AnimatedSprite.animation = "opengate"
			$AnimatedSprite.frame = spawn_frame
			$AnimatedSprite.play()
		else:
			$AnimatedSprite.animation = "flying"
			$AnimatedSprite.play()
	elif $AnimatedSprite.animation == "opengate":
		spawn_frame = -1
		$AnimatedSprite.animation = "flying"
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.animation = "flying"
		$AnimatedSprite.play()


func _on_AnimatedSprite_frame_changed() -> void:
	if $AnimatedSprite.animation == "opengate" && $AnimatedSprite.frame == 3:
		var drone = Drone.instance()
		drone.global_position = global_position
		drone.rotation = global_rotation
		get_tree().root.get_child(0).add_child(drone)
		drone.wake_up()
