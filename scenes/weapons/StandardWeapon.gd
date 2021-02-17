extends Node2D

var Projectile
export(float) var delay = 1
export var damage = 1

func _ready() -> void:
	Projectile = preload("res://scenes/entitys/Projectile.tscn")
	$Delay.wait_time = delay

	
func shoot() -> void:
	if !$Delay.is_stopped():
		return
	spawn_bullet()
	$Delay.start(0)
	
	
func spawn_bullet() -> void:
	var projectile = Projectile.instance()

	projectile.position = self.position + get_parent().position
	
	get_tree().root.get_child(0).add_child(projectile)
