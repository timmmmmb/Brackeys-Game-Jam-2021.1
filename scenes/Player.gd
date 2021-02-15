extends KinematicBody2D

export (int) var speed = 20
var velocity : Vector2 = Vector2(0, 0)


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")

	if left:
		velocity.x -= speed
	if right:
		velocity.x += speed
	if up:
		velocity.y -= speed
	if down:
		velocity.y += speed
		
	velocity = move_and_slide(velocity, Vector2(0, -1))


