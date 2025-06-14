extends CharacterBody2D

@export var FLY_SPEED = 10000;
@export var ACCELERATION = 500;
@export var SPEED = 100;

@onready var sprite = $"GhostGirl"
@onready var possessionzone = $"Possession_zone"
@onready var aura = $"Whitecircle"
var guy

var target_pos: Vector2
var target_possess: Moveable = null;
var going_to_scare = false;
var possessing: Moveable = null
var present = true
var aura_level = 3.5

func _ready() -> void:
	target_pos = global_position
	guy = get_parent().get_guy()
	#aura.material.shader.Intensity
	
func _physics_process(delta: float) -> void:
	if guy == null: guy = get_parent().get_guy()
	if present:
		if going_to_scare:
			target_pos = guy.global_position
			for b in possessionzone.get_overlapping_bodies():
				if b == guy:
					scare(guy)
		var dist = global_position.distance_to(target_pos)
		if dist < 20:
			velocity = velocity.move_toward(Vector2.ZERO, 10000*delta)
		else:
			var dir = global_position.direction_to(target_pos).normalized()
			velocity = velocity.move_toward(dir * FLY_SPEED, ACCELERATION * delta)
			if velocity.x > 0:
				sprite.position.x = -18
				sprite.flip_h = 1
			else:
				sprite.position.x = 8
				sprite.flip_h = 0
		
		var dist_from_guy = global_position.distance_to(guy.global_position)
		modulate[3] = min(1, dist_from_guy/280)
		move_and_slide()
	else:
		global_position = possessing.global_position

func set_target_pos(pos: Vector2):
	velocity = velocity.slide(global_position.direction_to(pos).normalized().rotated(-PI/2))
	if velocity*global_position.direction_to(pos) < Vector2.ZERO:
		velocity = Vector2.ZERO
	
	if possessing != null:
		unpossess()
	going_to_scare = false
	target_pos = pos

func set_target_possess(body: Moveable):
	if possessing != null and body != possessing:
		unpossess()
		going_to_scare = false
		target_possess = body
		target_pos = body.global_position
		velocity = velocity.slide(global_position.direction_to(target_pos).normalized().rotated(-PI/2))
	elif possessing == null:
		going_to_scare = false
		target_possess = body
		target_pos = body.global_position
		velocity = velocity.slide(global_position.direction_to(target_pos).normalized().rotated(-PI/2))
	
	for b in possessionzone.get_overlapping_bodies():
		if target_possess == b:
			possess(b)

func set_target_scare(body):
	if possessing != null:
		unpossess()
	target_pos = body.global_position
	going_to_scare = true

func scare(body):
	if body.frighten():
		going_to_scare = false
	target_pos = global_position
	velocity = Vector2.ZERO

func possess(body: Moveable):
	possessing = body
	target_possess = null
	fade_away()
	possessing.become_possessed(velocity/3)
	velocity = Vector2.ZERO

func unpossess():
	possessing.become_unpossessed()
	possessing = null
	unfade()

func fade_away():
	visible = false
	present = false

func unfade():
	visible = true
	present = true

func _on_possession_zone_body_entered(body: Node2D) -> void:
	if body == target_possess:
		possess(body)
	if going_to_scare and body == guy:
		scare(guy)
