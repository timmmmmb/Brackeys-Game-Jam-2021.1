extends "res://scenes/weapons/StandardWeapon.gd"

export var bullet_amount = 5
export(float) var bullet_delay = 0.05
var current_bullet = 0

func _ready() -> void:
	$Delay.wait_time = delay
	$BulletDelay.wait_time = bullet_delay
	
func shoot() -> void:
	if !$Delay.is_stopped():
		return
	current_bullet = 0
		
	spawn_bullet()
	$Delay.start(0)
	$BulletDelay.start(0)


func _on_BulletDelay_timeout() -> void:
	if current_bullet >= bullet_amount-1:
		return
	spawn_bullet()
	$BulletDelay.start(0)
	current_bullet += 1
