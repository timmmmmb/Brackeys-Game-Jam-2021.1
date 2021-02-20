extends  Level
class_name Cutscene

var screens
var current_screen
var screen_index = 0

func _ready() -> void:
	screens = $Text.get_children()
	next_screen()


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("ui_accept") && $PressDelay.is_stopped() :
		next_screen()
		$PressDelay.start(0)


func next_screen():
	if screens.size() <= screen_index:
		finish_level()
		$Timer.stop()
		return
	if current_screen != null:
		current_screen.visible = false
	current_screen = screens[screen_index]
	current_screen.visible = true
	screen_index += 1

