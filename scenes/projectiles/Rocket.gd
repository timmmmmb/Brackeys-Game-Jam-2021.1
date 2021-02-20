extends Projectile
class_name Rocket

var target

func move():
	if $AnimatedSprite.animation != "hit":
		if target:
			look_at(target.global_position)
			position += global_position.direction_to(target.global_position) * speed
		else:
			position += Vector2.UP.rotated(rotation) * speed



func _on_Timer_timeout() -> void:
	$AnimatedSprite.animation = "hit"
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.play()
	yield($AnimatedSprite, "animation_finished" )
	queue_free()
