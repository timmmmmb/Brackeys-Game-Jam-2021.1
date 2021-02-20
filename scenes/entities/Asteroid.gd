extends Entity

enum STATE {IDLE, MOVING, ORBITING}
var state = STATE.IDLE
export(float) var rotation_speed
export(int) var asteroid_type = 0
export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0


func _ready():
	$Sprite.frame = asteroid_type
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()


func _physics_process(delta):
	if patrol_path:
		var target = patrol_points[patrol_index]
		if position.distance_to(target) < 1:
			patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
			target = patrol_points[patrol_index]
		velocity = (target - position).normalized() * speed
		velocity = move_and_slide(velocity)
		state = STATE.ORBITING
	rotation_degrees = rotation_speed*delta + rotation_degrees
	


func hit(_damage):
	pass
