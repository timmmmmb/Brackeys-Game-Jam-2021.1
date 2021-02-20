extends Node2D

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	get_tree().change_scene("res://scenes/levels/MainLevel.tscn")

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("ui_accept") && $PressDelay.is_stopped():
		next_screen()
		$PressDelay.start(0)


func next_screen():
	var current_time = $AnimationPlayer.get_current_animation_position()
	var current_keyindex = $AnimationPlayer.get_animation("Intro").track_find_key(0, current_time)
	if current_keyindex+1 >= 10:
		$AnimationPlayer.stop()
		_on_AnimationPlayer_animation_finished("Intro")
		return
	$AnimationPlayer.advance($AnimationPlayer.get_animation("Intro").track_get_key_time(0, current_keyindex+1)-$AnimationPlayer.get_current_animation_position())
