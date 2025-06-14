extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayButton

func _ready():
	play_button.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	var new_scene = load("res://Scenes/Levels/level1.tscn")  # Replace with your scene path
	get_tree().change_scene_to_packed(new_scene)
