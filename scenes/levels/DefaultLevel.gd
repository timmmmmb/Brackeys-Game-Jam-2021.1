extends Node2D
class_name Level

signal level_finished

func _ready() -> void:
	var children_nodes = $Enemys.get_children()
	for child in children_nodes: 
		child.connect("death", self, "enemy_died")

# used to add animation on level entry
func add():
	wake_up()


func wake_up():
	var children_nodes = $Enemys.get_children()
	for child in children_nodes: 
		child.wake_up()


# used to add animation on level removal
func remove():
	queue_free()


func finish_level() -> void:
	emit_signal("level_finished")


func enemy_died():
	if $Enemys.get_child_count() <= 1:
		finish_level()
