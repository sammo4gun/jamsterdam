extends Area2D

@export var next_scene_path: String = "res://Scenes/Levels/level2.tscn"

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Player picked up the rose!")
		get_tree().change_scene_to_file(next_scene_path)
