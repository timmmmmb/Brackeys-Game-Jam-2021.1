extends "res://scenes/entities/DefaultEntity.gd"
class_name Enemy

enum STATE {IDLE, MOVING, ATTACKING}
var state = STATE.IDLE
export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0
export(float) var attack_delay = 1
export (NodePath) var weapon

func _ready():
	$AttackDelay.wait_time = attack_delay
	current_weapon = get_node(weapon)
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()

func wake_up():
	state = STATE.MOVING
	$AttackDelay.start(0)
	$AnimatedSprite.animation = "flying"
	$AnimatedSprite.play()


func _physics_process(_delta):
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
	if $AnimatedSprite.animation == "hit":
		return
	health -= damage
	if health <= 0:
		destroy()
	else:
		$AnimatedSprite.animation = "hit"
		$AnimatedSprite.play()


func destroy():
	$AnimatedSprite.animation = "die"
	$CollisionShape2D.call_deferred("disabled", true)
	state = STATE.IDLE
	$AnimatedSprite.play()


func _on_AttackDelay_timeout() -> void:
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
