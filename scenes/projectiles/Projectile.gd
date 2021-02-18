extends Area2D

export (int) var speed = 2

func _ready() -> void:
	$AnimatedSprite.play()


func _physics_process(delta: float) -> void:
	if $AnimatedSprite.animation != "hit":
		position += Vector2.UP.rotated(rotation) * speed


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Projectile_body_entered(body: Node) -> void:
	if body is DefaultEntity:
		body.hit(1)
		$AnimatedSprite.animation = "hit"
		$AnimatedSprite.play()
		$CollisionShape2D.disabled = true


func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "hit":
		queue_free()
