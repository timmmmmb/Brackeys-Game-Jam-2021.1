extends Level
class_name EnemyLevel

func add():
	$AnimationPlayer.play("add")
	yield($AnimationPlayer, "animation_finished" )
	wake_up()
