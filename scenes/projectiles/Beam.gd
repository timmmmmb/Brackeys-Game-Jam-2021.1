extends Area2D


func _on_Area2D_body_entered(body: Node) -> void:
	if body is DefaultEntity:
		body.hit(1)


func _on_AnimatedSprite_frame_changed() -> void:
	if $AnimatedSprite.frame == 3:
		$CollisionShape2D.disabled = false
	elif $AnimatedSprite.frame == 4:
		$CollisionShape2D.disabled = true
