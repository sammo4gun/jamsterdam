extends Node2D

@onready var Ghost = $"Ghost"

func attempt_possession(body: CharacterBody2D):
	Ghost.set_target_possess(body)

func _on_background_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Ghost.set_target_pos(event.global_position)
