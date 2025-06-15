extends Control


func _ready():
	$Tutorial.continue_pressed.connect(_on_continue_pressed)

func _on_continue_pressed():
	var new_scene = load("res://Scenes/Levels/level1.tscn")  # Replace with your scene path
	get_tree().change_scene_to_packed(new_scene)
