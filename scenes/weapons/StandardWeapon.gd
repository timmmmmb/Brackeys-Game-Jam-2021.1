extends Node2D
class_name Weapon

export(PackedScene) var Projectile = preload("res://scenes/projectiles/Projectile.tscn")
export(float) var delay = 1
export var damage = 1
var disable_shooting = false

func _ready() -> void:
	$Delay.wait_time = delay

	
func shoot() -> void:
	if !$Delay.is_stopped() || disable_shooting:
		return
	spawn_bullet()
	$Delay.start(0)
	
	
func spawn_bullet() -> void:
	$Sound.play(0)
	var projectile = Projectile.instance()
	
	projectile.global_position = global_position
	projectile.rotation = global_rotation
	get_tree().root.get_child(0).add_child(projectile)
