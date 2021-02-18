extends Node2D

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -10)


func _process(_delta):
	var accept = Input.is_action_just_pressed("ui_accept")
	if accept && $AnimationPlayer.current_animation != "Start" && !$Enter.playing:
		$Enter.play()
		yield($Enter, "finished")
		$AnimationPlayer.play("Start")
		yield($AnimationPlayer, "animation_finished")
		get_tree().change_scene("res://scenes/Cutscenes.tscn")
