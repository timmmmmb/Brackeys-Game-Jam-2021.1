extends KinematicBody2D

export var health = 3
export var speed = 10
var current_weapon

func shoot():
	current_weapon.shoot()

func hit(damage):
	health -= damage
	if health <= 0:
		destroy()

func destroy():
	pass
