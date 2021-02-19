extends "res://scenes/entities/DefaultEntity.gd"

export (NodePath) var weapon


func _ready() -> void:
	current_weapon = get_node(weapon)


func shoot() -> void:
	$StandardWeapon.shoot()


func hit(damage) -> void:
	health -= damage
	if health <= 0:
		destroy()


func destroy() -> void:
	queue_free()
