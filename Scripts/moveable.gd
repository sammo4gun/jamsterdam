class_name Moveable extends RigidBody2D

@onready var world = get_parent()
@onready var shape = $"Shape"
@onready var guy = null
@onready var guyfinder = $"GuyFinder"
@onready var aura = $"Whitecircle"

@export var speed = 3000
@export var baseweight = 8
@export var changeweight = 7

var possessed = false
var weight = 0
var connected_guy = false

var corr_aura_scale

func _ready() -> void:
	weight = baseweight + (scale.x * scale.y) * changeweight
	corr_aura_scale = aura.scale
	aura.scale *= 0.01

func get_input(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var target_velocity = input_direction * speed / weight
	if connected_guy:
		target_velocity = target_velocity / 4
	linear_velocity = linear_velocity.move_toward(target_velocity, 1000 * delta)
	if connected_guy and linear_velocity.y < 0:
		guy.get_parent().velocity.y = linear_velocity.y

func _physics_process(delta):
	if possessed:
		$"Whitecircle/PointLight2D".visible = true
		if aura.scale.x < corr_aura_scale.x/2:
			aura.scale = corr_aura_scale/2
		if aura.scale.x < corr_aura_scale.x:
			aura.scale *= 1.1
		if len(guyfinder.get_overlapping_areas()) == 0:
			connected_guy = false
			guy = null
		for b in guyfinder.get_overlapping_areas():
			if b.is_in_group("Guy"):
				connected_guy = true
				guy = b
				break
			connected_guy = false
			guy = null
		get_input(delta)
	else:
		if aura.scale.x > 0.01:
			aura.scale *= 0.97
		$"Whitecircle/PointLight2D".visible = false

func _on_input_event(viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	viewport.set_input_as_handled()
	if event is InputEventMouseButton and event.pressed:
		world.attempt_possession(self)

func become_possessed(vel: Vector2):
	linear_velocity = vel
	physics_material_override.friction = 0.0
	angular_damp = 70.0
	gravity_scale = 0
	possessed = true

func become_unpossessed():
	physics_material_override.friction = 1.0
	angular_damp = 4.0
	gravity_scale = 1
	possessed = false
