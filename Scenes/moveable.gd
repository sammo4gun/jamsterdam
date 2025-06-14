extends CharacterBody2D

@onready var world = get_parent()

var possessed = false
@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	if possessed:
		get_input()
		move_and_slide()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	get_viewport().set_input_as_handled()
	if event is InputEventMouseButton and event.pressed:
		world.attempt_possession(self)

func become_possessed():
	possessed = true

func become_unpossessed():
	possessed = false
