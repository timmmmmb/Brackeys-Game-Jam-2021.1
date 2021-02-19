extends Projectile
class_name Rocket

var target

func _physics_process(_delta: float) -> void:
	if $AnimatedSprite.animation != "hit":
		if target:
			position += position.direction_to(target.position) * speed
		else:
			position += Vector2.UP.rotated(rotation) * speed



func _on_Timer_timeout() -> void:
	$AnimatedSprite.animation = "hit"
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.play()
	yield($AnimatedSprite, "animation_finished" )
	queue_free()
