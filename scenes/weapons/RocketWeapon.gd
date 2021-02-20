extends Weapon

export(PackedScene) var Rocket = preload("res://scenes/projectiles/Rocket.tscn")

func spawn_bullet() -> void:
	$Sound.play(0)
	var projectile = Rocket.instance()
	if get_tree().get_nodes_in_group("player").size() >= 1:
		projectile.target = get_tree().get_nodes_in_group("player")[0]

	#projectile.position = self.position + get_parent().position
	#projectile.rotation = self.rotation
	projectile.global_position = global_position
	projectile.rotation = global_rotation
	get_tree().root.get_child(0).add_child(projectile)
