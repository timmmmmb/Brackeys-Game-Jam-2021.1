extends AnimatedSprite

export (bool) var is_available = true


func _ready() -> void:
	self.playing = true


func _process(delta: float) -> void:
	if is_available:
		self.animation = "full"
	else:
		self.animation = "empty"
