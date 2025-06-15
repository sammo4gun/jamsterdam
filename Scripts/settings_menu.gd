extends Control

signal back_pressed

@onready var back_button = $VBoxContainer/BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	emit_signal("back_pressed")
