extends Node2D

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	get_tree().change_scene("res://scenes/levels/MainLevel.tscn")
