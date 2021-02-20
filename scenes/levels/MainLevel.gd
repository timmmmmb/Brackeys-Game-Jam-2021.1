extends Node2D

var levels = [ 
	preload("res://scenes/levels/TutorialLevel1.tscn"), 
	preload("res://scenes/levels/TutorialLevel2.tscn"), 
	preload("res://scenes/levels/TutorialLevel3.tscn"), 
	preload("res://scenes/levels/TutorialLevel4.tscn"),
	preload("res://scenes/levels/TutorialLevel5.tscn"),
	
	preload("res://scenes/levels/Level1_1_Title.tscn"),
	preload("res://scenes/levels/Level1_2.tscn"),
	preload("res://scenes/levels/Level1_3.tscn"),
	preload("res://scenes/levels/Level1_4.tscn"),
	preload("res://scenes/levels/Level1_5.tscn"),
	
	preload("res://scenes/levels/Level2_1_Title.tscn"),
	preload("res://scenes/levels/Level2_2.tscn"),
	preload("res://scenes/levels/Level2_3_Cutscene.tscn"),
	preload("res://scenes/levels/Level2_4.tscn"),
	preload("res://scenes/levels/Level2_5.tscn"),
	
	preload("res://scenes/levels/Level3_1_Title.tscn"),
	preload("res://scenes/levels/Level3_2.tscn"),
	preload("res://scenes/levels/Level3_3.tscn"),
	preload("res://scenes/levels/Level3_4.tscn"),
	preload("res://scenes/levels/Level3_5.tscn"),
	
	preload("res://scenes/levels/Level4_1_Title.tscn"),
	preload("res://scenes/levels/Level4_2.tscn"),
	preload("res://scenes/levels/Level4_3.tscn"),
	preload("res://scenes/levels/Level4_4.tscn"),
	preload("res://scenes/levels/Level4_5.tscn"),
	
	preload("res://scenes/levels/Level5_1_Title.tscn"),
	preload("res://scenes/levels/Level5_2.tscn"),
	preload("res://scenes/levels/Level5_3_Cutscene.tscn"),
	preload("res://scenes/levels/Level5_4_Boss.tscn"),
	preload("res://scenes/levels/Level5_5_Cutscene.tscn")
]
var level_index = 0
var current_level: Level
var old_level: Level
export(PackedScene) var PlayerScene = preload("res://scenes/entities/Player.tscn")
var player: Player
var friendly_amount = 0
var save_level = 0


func _ready() -> void:
	player = $Player
	load_level()
	move_level()


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("restart") && $LifeBar.hearts <= 0:
		restart()


func load_level():
	if level_index >= levels.size():
		return
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
		get_tree().change_scene("res://scenes/WinScreen.tscn")
		return
	if (level_index) % 5 == 0:
		save()
	load_level()
	move_level()
	despawn_level()


func game_over():
	$GameOver.visible = true


func restart():
	level_index = save_level
	player = PlayerScene.instance()
	get_tree().root.get_child(0).add_child(player)
	for i in range(friendly_amount):
		player._add_new_friendly()
	$GameOver.visible = false
	$LifeBar.hearts = 3
	var bullets = get_children()
	player.connect("death", self, "game_over")
	player.connect("hit", $LifeBar, "sync_health")
	for child in bullets: 
		if child is Projectile:
			child.queue_free()
		elif child is Enemy:
			child.queue_free()
	load_level()
	despawn_level()
	move_level()


func save():
	if player != null:
		friendly_amount = player.friendly_amount
		save_level = level_index
