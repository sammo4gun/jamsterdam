class_name Moveable extends CharacterBody2D

@onready var world = get_parent()
@onready var shape = $"Shape"

@export var speed = 3000
@export var baseweight = 8
@export var changeweight = 7

var possessed = false
var weight = 0

func _ready() -> void:
	weight = baseweight + (scale.x * scale.y) * changeweight

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed / weight

func _physics_process(delta):
	if possessed:
		get_input()
		move_and_slide()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	get_viewport().set_input_as_handled()
	if event is InputEventMouseButton and event.pressed:
		world.attempt_possession(self)

func become_possessed():
	possessed = true

func become_unpossessed():
	possessed = false
