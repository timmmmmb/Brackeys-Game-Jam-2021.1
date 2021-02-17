extends "res://scenes/weapons/StandardWeapon.gd"

export var bullet_amount = 5
export var spread = 30

func _ready() -> void:
	Projectile = preload("res://scenes/entitys/Projectile.tscn")
	$Delay.wait_time = delay
	
func shoot() -> void:
	if !$Delay.is_stopped():
		return
		
	spawn_bullet()
	$Delay.start(0)

func spawn_bullet() -> void:
	for i in range(bullet_amount):
		var projectile = Projectile.instance()
	
		projectile.position = self.position + get_parent().position
		projectile.rotation = self.rotation + deg2rad((spread / bullet_amount * (i+0.5)) - float(spread / 2))
		get_tree().root.get_child(0).add_child(projectile)
