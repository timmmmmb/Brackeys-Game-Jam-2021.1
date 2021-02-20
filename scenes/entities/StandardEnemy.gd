extends Entity
class_name Enemy

enum STATE {IDLE, MOVING, ATTACKING, DEAD}
var state = STATE.IDLE
export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0
export(float) var attack_delay = 1
export (NodePath) var weapon

func _ready():
	$AttackDelay.wait_time = attack_delay
	current_weapon = get_node(weapon)

func wake_up():
	state = STATE.MOVING
	$AttackDelay.start(0)
	$AnimatedSprite.animation = "flying"
	$AnimatedSprite.play()
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()


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

func _physics_process(_delta):
	behaviour()


func hit(damage):
	if $AnimatedSprite.animation == "die":
		return
	health -= damage
	if health <= 0:
		destroy()
	else:
		$AnimatedSprite.animation = "hit"
		$AnimatedSprite.play()


func destroy():
	$AnimatedSprite.animation = "die"
	current_weapon.disable_shooting = true
	$CollisionShape2D.set_deferred("disabled", true)
	state = STATE.DEAD
	$AttackDelay.stop()
	$AnimatedSprite.play()


func _on_AttackDelay_timeout() -> void:
	if state == STATE.DEAD:
		return
	state = STATE.ATTACKING


func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "die":
		emit_signal("death")
		queue_free()
	elif $AnimatedSprite.animation == "hit" :
		$AnimatedSprite.animation = "flying"
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.animation = "flying"
		$AnimatedSprite.play()
