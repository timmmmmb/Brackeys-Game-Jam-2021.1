extends Node2D

export (int) var hearts = 3


func _ready() -> void:
	$Heart1.frame = 0
	$Heart2.frame = 1
	$Heart3.frame = 2


func _process(_delta: float) -> void:
	$Heart1.is_available = hearts >= 1
	$Heart2.is_available = hearts >= 2
	$Heart3.is_available = hearts >= 3
	pass


func sync_health(health) -> void:
	hearts = health
