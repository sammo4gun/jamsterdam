extends Node2D

@onready var Ghost = $"Ghost"
@onready var pause_menu = $PauseMenu
@onready var Guy = $"Guy"

func attempt_possession(body: Moveable):
	Ghost.set_target_possess(body)

func _on_background_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Ghost.set_target_pos(event.global_position)
