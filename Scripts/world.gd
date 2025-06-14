extends Node2D

@onready var Ghost = $"Ghost"

func _unhandled_input(event: InputEvent) -> void:
	## Mouse in viewport coordinates.
	pass

func attempt_possession(body: CharacterBody2D):
	Ghost.set_target_possess(body)

func _on_background_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Ghost.set_target_pos(event.global_position)
	pass # Replace with function body.
