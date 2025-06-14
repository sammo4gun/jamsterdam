extends Control

@onready var settings_button: Button = $VBoxContainer/BackButton

func _ready():
	settings_button.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	visible = false
