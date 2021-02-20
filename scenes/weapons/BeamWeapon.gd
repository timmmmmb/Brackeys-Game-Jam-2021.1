extends Weapon

func shoot() -> void:
	if !$Delay.is_stopped() || disable_shooting:
		return
	$Beam/AnimatedSprite.frame = 0
	$Beam/AnimatedSprite.play("default")
	$Delay.start(0)
