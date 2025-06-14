extends Control

@onready var resume_button: Button = $MarginContainer/VBoxContainer/ResumeButton

func _ready():
	resume_button.pressed.connect(_on_resume_pressed)

func _input(event):
	if event.is_action_pressed("esc"):
		toggle_pause_menu()

func toggle_pause_menu():
	var is_paused = get_tree().paused
	get_tree().paused = !is_paused
	visible = !is_paused

func _on_resume_pressed():
	toggle_pause_menu()
