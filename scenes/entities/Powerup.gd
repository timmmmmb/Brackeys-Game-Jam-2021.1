tool
extends Area2D

enum PowerupType { SHOOT_FAST, MULTISHOT, SLOW_ENEMIES } # Also in Player

export (PowerupType) var type = PowerupType.SHOOT_FAST
export (int) var duration = 5


func _process(delta: float) -> void:
	$Sprite.frame = type
