extends "res://scenes/entitys/DefaultEntity.gd"

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
	wake_up()

func wake_up():
	state = STATE.MOVING
	$AttackDelay.start(0)


func _physics_process(delta):
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
	health -= damage
	if health <= 0:
		destroy()


func destroy():
	queue_free()


func _on_AttackDelay_timeout() -> void:
	state = STATE.ATTACKING
