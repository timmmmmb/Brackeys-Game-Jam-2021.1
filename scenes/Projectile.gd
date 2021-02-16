extends KinematicBody2D

export (int) var speed = 2

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	position += Vector2.UP.rotated(rotation) * speed


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
