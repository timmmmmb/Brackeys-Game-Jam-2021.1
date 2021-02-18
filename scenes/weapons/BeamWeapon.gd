extends StandardWeapon

func shoot() -> void:
	if !$Delay.is_stopped():
		return
	$Beam/AnimatedSprite.frame = 0
	$Beam/AnimatedSprite.play("default")
	$Delay.start(0)
