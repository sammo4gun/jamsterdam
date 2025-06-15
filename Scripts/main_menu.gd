extends Control

@onready var play_button: Button = $MenuControls/MarginContainer/VBoxContainer/PlayButton
@onready var settings_button = $MenuControls/MarginContainer/VBoxContainer/SettingsButton
@onready var settings_menu = $SettingsMenu
@onready var menu_controls = $MenuControls

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	settings_menu.back_pressed.connect(_on_settings_back_pressed)

func _on_play_pressed():
	var new_scene = load("res://Scenes/intro_screen.tscn")  # Replace with your scene path
	get_tree().change_scene_to_packed(new_scene)

func _on_settings_pressed():
	settings_menu.visible = true
	menu_controls.visible = false

func _on_settings_back_pressed():
	settings_menu.visible = false
	menu_controls.visible = true
