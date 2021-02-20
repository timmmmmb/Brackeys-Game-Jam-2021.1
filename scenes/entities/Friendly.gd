extends Entity
class_name Friendly

export (NodePath) var weapon
signal picked_up

var initial_position: Vector2
var floating_distance: int = 5
var floating_time: int = 2
var time: float = 0

var picked_up = false

func pick_uo():
	picked_up = true
	emit_signal("picked_up")


func _ready() -> void:
	current_weapon = get_node(weapon)
	initial_position = position


func _process(delta: float) -> void:
	if not picked_up:
		time = fmod(time + delta, floating_time)
		self.position.y = initial_position.y + \
				sin(time * TAU / floating_time) * floating_distance
	

func shoot() -> void:
	current_weapon.shoot()


func hit(damage) -> void:
	health -= damage
	if health <= 0:
		destroy()


func destroy() -> void:
	queue_free()
