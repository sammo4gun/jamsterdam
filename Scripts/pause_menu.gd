extends Control

@onready var resume_button: Button = $MarginContainer/VBoxContainer/ResumeButton
@onready var shader_material: ShaderMaterial = $ColorRect.material as ShaderMaterial

func _ready():
	resume_button.pressed.connect(_on_resume_pressed)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause_menu()

func toggle_pause_menu():
	var is_paused = get_tree().paused
	get_tree().paused = !is_paused

	if !is_paused:
		# Show and fade in
		visible = true
		modulate.a = 0.0
		fade_in_shader()
		fade_in_menu()
	else:
		# Fade out and then hide
		fade_out_shader()
		fade_out_menu()

func _on_resume_pressed():
	toggle_pause_menu()

# === SHADER ANIMATION ===

func fade_in_shader():
	var start_value: float = shader_material.get_shader_parameter("mix_percentage")
	var end_value: float = 0.2
	var tween = create_tween()
	tween.tween_method(
		func(value): shader_material.set_shader_parameter("mix_percentage", value),
		start_value,
		end_value,
		0.3
	)

func fade_out_shader():
	var start_value: float = shader_material.get_shader_parameter("mix_percentage")
	var end_value: float = 0.0
	var tween = create_tween()
	tween.tween_method(
		func(value): shader_material.set_shader_parameter("mix_percentage", value),
		start_value,
		end_value,
		0.3
	)

# === UI FADE ANIMATION ===

func fade_in_menu():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)

func fade_out_menu():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_callback(Callable(self, "_on_fade_out_complete"))

func _on_fade_out_complete():
	visible = false
