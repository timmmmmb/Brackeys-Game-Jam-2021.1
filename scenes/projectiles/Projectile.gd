extends Area2D

export (int) var speed = 2

func _ready() -> void:
	$AnimatedSprite.play()


func _physics_process(delta: float) -> void:
	position += Vector2.UP.rotated(rotation) * speed


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Projectile_body_entered(body: Node) -> void:
	if body is DefaultEntity:
		body.hit(1)
		queue_free()
