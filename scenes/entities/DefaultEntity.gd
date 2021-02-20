extends KinematicBody2D
class_name Entity

signal death

export var health = 3
export var speed = 10
var current_weapon
var velocity : Vector2 = Vector2(0, 0)

func shoot():
	if current_weapon:
		current_weapon.shoot()

func hit(damage):
	health -= damage
	if health <= 0:
		destroy()

func destroy():
	current_weapon.disable_shooting = true
	emit_signal("death")
