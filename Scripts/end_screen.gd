extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/ReturnButton

func _ready():
	play_button.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	var new_scene = load("res://Scenes/main_menu.tscn")  # Replace with your scene path
	get_tree().change_scene_to_packed(new_scene)
