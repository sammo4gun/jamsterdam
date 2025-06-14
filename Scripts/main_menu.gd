extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayButton
@onready var settings_button: Button = $MarginContainer/VBoxContainer/SettingsButton
@onready var settings_menu: PanelContainer = $SettingsMenu

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)

func _on_play_pressed():
	var new_scene = load("res://Scenes/Levels/level1.tscn")  # Replace with your scene path
	get_tree().change_scene_to_packed(new_scene)

func _on_settings_pressed():
	settings_menu.visible = true
