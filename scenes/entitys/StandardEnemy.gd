extends "res://scenes/entitys/DefaultEntity.gd"

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
