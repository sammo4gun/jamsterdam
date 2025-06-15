extends Control

@onready var resume_button = $Main/VBoxContainer/ResumeButton
@onready var settings_button = $Main/VBoxContainer/SettingsButton
@onready var main_panel = $Main
@onready var settings_panel = $Settings
@onready var shader_material = $ColorRect.material as ShaderMaterial
@onready var tutorial_button = $Main/VBoxContainer/TutorialButton
@onready var tutorial_panel = $Tutorial


func _ready():
	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	tutorial_button.pressed.connect(_on_tutorial_pressed)
	settings_panel.back_pressed.connect(_on_settings_back_pressed)
	tutorial_panel.continue_pressed.connect(_on_tutorial_continue_pressed)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause_menu()

func toggle_pause_menu():
	var is_paused = get_tree().paused
	get_tree().paused = !is_paused

	if !is_paused:
		# Show and fade in
		visible = true
		main_panel.visible = true
		settings_panel.visible = false
		modulate.a = 0.0
		fade_in_shader()
		fade_in_menu()
	else:
		# Fade out and then hide
		fade_out_shader()
		fade_out_menu()

func _on_resume_pressed():
	toggle_pause_menu()

func _on_settings_pressed():
	main_panel.visible = false
	settings_panel.visible = true

func _on_settings_back_pressed():
	main_panel.visible = true
	settings_panel.visible = false

func _on_tutorial_pressed():
	main_panel.visible = false
	tutorial_panel.visible = true

func _on_tutorial_continue_pressed():
	main_panel.visible = true
	tutorial_panel.visible = false

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
