extends Node2D

var levels = [preload("res://scenes/levels/TutorialLevel1.tscn"), preload("res://scenes/levels/TutorialLevel2.tscn"), preload("res://scenes/levels/TutorialLevel3.tscn"), preload("res://scenes/levels/TutorialLevel4.tscn"), preload("res://scenes/levels/Cutscene1.tscn"), preload("res://scenes/levels/Cutscene2.tscn"), preload("res://scenes/levels/Cutscene3.tscn")]
var level_index = 0
var current_level: Level
var old_level: Level
export(PackedScene) var Player = preload("res://scenes/entities/Player.tscn")
var player: Player


func _ready() -> void:
	player = $Player
	load_level()
	move_level()


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("restart") && $LifeBar.hearts == 0:
		restart()


func load_level():
	var level = levels[level_index].instance()
	level.connect("level_finished", self, "next_level")
	old_level = current_level
	current_level = level
	get_tree().root.get_child(0).add_child(level)
	if level is Cutscene:
		player.visible = false
		player.set_paused(true)
	else:
		player.visible = true
		player.set_paused(false)
	level_index += 1

func move_level():
	if current_level != null:
		current_level.add()


func despawn_level():
	if old_level != null:
		old_level.remove()


func next_level():
	if level_index >= levels.size():
		return
	load_level()
	move_level()
	despawn_level()

func game_over():
	$GameOver.visible = true


func restart():
	level_index = 0
	player = Player.instance()
	get_tree().root.get_child(0).add_child(player)
	$GameOver.visible = false
	$LifeBar.hearts = 3
	var bullets = get_children()
	player.connect("death", self, "game_over")
	player.connect("hit", $LifeBar, "sync_health")
	for child in bullets: 
		if child is Projectile:
			child.queue_free()
	load_level()
	despawn_level()
	move_level()



