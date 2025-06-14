class_name Moveable extends CharacterBody2D

@onready var world = get_parent()
@onready var shape = $"Shape"
@onready var guy = null

@export var speed = 2000
@export var baseweight = 8
@export var changeweight = 7

var possessed = false
var weight = 0
var connected_guy = false

func _ready() -> void:
	weight = baseweight + (scale.x * scale.y) * changeweight

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed / weight
	if connected_guy:
		velocity = velocity / 4
		if velocity.y < 0:
			guy.velocity.y = velocity.y/2

func _physics_process(delta):
	if possessed:
		if get_slide_collision_count() == 0:
			connected_guy = false
			guy = null
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i).get_collider()
			if collision.is_in_group('Guy'):
				connected_guy = true
				guy = collision
				break
			connected_guy = false
			guy = null
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
