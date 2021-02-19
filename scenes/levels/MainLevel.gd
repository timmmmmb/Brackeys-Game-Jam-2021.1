extends Node2D

var levels = [preload("res://scenes/levels/TutorialLevel1.tscn"), preload("res://scenes/levels/TutorialLevel2.tscn"), preload("res://scenes/levels/TutorialLevel3.tscn"), preload("res://scenes/levels/TutorialLevel4.tscn")]
var level_index = 0
var current_level: Level
var old_level: Level

func _ready() -> void:
	load_level()
	move_level()

func load_level():
	if level_index >= levels.size():
		return
	var level = levels[level_index].instance()
	level.connect("level_finished", self, "next_level")
	old_level = current_level
	current_level = level
	get_tree().root.get_child(0).add_child(level)
	level_index += 1

func move_level():
	current_level.add()


func despawn_level():
	old_level.remove()


func next_level():
	load_level()
	move_level()
	despawn_level()
