extends  Level
class_name Cutscene

var screens = []
var current_screen
var screen_index

func _ready() -> void:
	next_screen()


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		next_screen()


func next_screen():
	if screens.size() <= screen_index:
		finish_level()
		$Timer.stop()
		return
	current_screen.visible = false
	current_screen = screens[screen_index]
	current_screen.visible = true
	screen_index += 1

