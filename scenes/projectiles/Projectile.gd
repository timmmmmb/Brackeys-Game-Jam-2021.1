extends Area2D
class_name Projectile
export (int) var speed = 2

func _ready() -> void:
	$AnimatedSprite.play()


func move():
	if $AnimatedSprite.animation != "hit":
		position += Vector2.UP.rotated(rotation) * speed
	

func _physics_process(_delta):
	move()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Projectile_body_entered(body: Node) -> void:
	if body is Entity:
		body.hit(1)
		$AnimatedSprite.animation = "hit"
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite.play()
		yield($AnimatedSprite, "animation_finished" )
		queue_free()
