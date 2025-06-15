extends Control

signal continue_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ContinueButton.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	emit_signal("continue_pressed")
