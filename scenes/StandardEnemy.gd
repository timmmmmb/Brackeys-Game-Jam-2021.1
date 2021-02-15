extends KinematicBody2D

var health = 3
var speed = 10

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
	
func shoot():
	pass

func hit(damage):
	health -= damage
	if health <= 0:
		destroy()

func destroy():
	pass

func _on_BulletTimer_timeout():
	shoot()
