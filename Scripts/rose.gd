extends Area2D

func _ready():
	self.body_entered.connect(_on_body_entered)

func next_level():
	var current_name = get_tree().current_scene.name

	# Use regex to extract digits from the name
	var regex = RegEx.new()
	regex.compile(r"\d+")
	var result = regex.search(current_name)

	if result:
		var number = int(result.get_string())
		var next_number = number + 1
		var next_scene_path = "res://Scenes/Levels/level%d.tscn" % next_number
		get_tree().change_scene_to_file(next_scene_path)
	else:
		print("No number found in scene name")

func _on_body_entered(body):
	if body.is_in_group("Guy"):
		next_level()
