extends Area2D


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Entity:
		body.hit(1)


func _on_AnimatedSprite_frame_changed() -> void:
	if $AnimatedSprite.frame == 6:
		$CollisionShape2D.set_deferred("disabled", false)
	elif $AnimatedSprite.frame == 7:
		$CollisionShape2D.set_deferred("disabled", true)
