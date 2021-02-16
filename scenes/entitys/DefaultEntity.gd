extends KinematicBody2D

export var health = 3
export var speed = 10
var Projectile

func shoot():
	pass

func hit(damage):
	health -= damage
	if health <= 0:
		destroy()

func destroy():
	pass
