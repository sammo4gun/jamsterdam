extends Node2D

@onready var Ghost = $"Ghost"
@onready var pause_menu = $PauseMenu



func _unhandled_input(event: InputEvent) -> void:
	## Mouse in viewport coordinates.
	#if event is InputEventMouseButton and event.pressed:
		#Ghost.set_target_pos(event.global_position)
	pass

func attempt_possession(body: CharacterBody2D):
	Ghost.set_target_possess(body)
