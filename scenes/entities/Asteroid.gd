extends Entity

export(float) var rotation_speed
export(int) var asteroid_type = 0


func _ready():
	$Sprite.frame = asteroid_type


func _physics_process(delta):
	rotation_degrees = rotation_speed*delta + rotation_degrees


func hit(_damage):
	pass
