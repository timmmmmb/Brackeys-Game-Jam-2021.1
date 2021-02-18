extends Node2D

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -5)


func _process(_delta):
	var accept = Input.is_action_just_pressed("ui_accept")
	if accept:
		$Enter.play()
		yield($Enter, "finished")
		get_tree().change_scene("res://scenes/levels/Level.tscn")
