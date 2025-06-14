extends Control

@onready var resume_button: Button = $MarginContainer/VBoxContainer/ResumeButton
@onready var shader_material := $ColorRect.material as ShaderMaterial

# Menu Functionality
func _ready():
	resume_button.pressed.connect(_on_resume_pressed)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause_menu()

func toggle_pause_menu():
	var is_paused = get_tree().paused
	get_tree().paused = !is_paused
	visible = !is_paused
	if (visible):
		fade_in_shader()
	else:
		fade_out_shader()

func _on_resume_pressed():
	toggle_pause_menu()

# Shader animation
func fade_in_shader():
	shader_material.set_shader_parameter("mix_percentage", 0.0)  # Set initial value
	var tween = create_tween()
	tween.tween_property(
		shader_material,
		"shader_param/mix_percentage",
		0.5,  # target value
		0.4   # duration in seconds
	)

func fade_out_shader():
	var tween = create_tween()
	tween.tween_property(
		shader_material,
		"shader_param/mix_percentage",
		0.0,
		0.4
	)
