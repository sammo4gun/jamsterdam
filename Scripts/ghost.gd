extends CharacterBody2D

@export var FLY_SPEED = 1000;
@onready var sprite = $"Sprite"

var target_pos: Vector2
var target_possess = null;
var possessing = null
var present = true

func _physics_process(delta: float) -> void:
	if present:
		var dist = global_position.distance_to(target_pos)
		if dist < 20:
			velocity = Vector2.ZERO
		else:
			var dir = global_position.direction_to(target_pos).normalized()
			
			velocity = dir * FLY_SPEED
			if velocity.x > 0:
				sprite.flip_h = 0
			else:
				sprite.flip_h = 1
		move_and_slide()
	else:
		global_position = possessing.global_position
	#print(possessing)

func set_target_pos(pos: Vector2):
	print('yu')
	if possessing != null:
		unpossess()
	target_pos = pos

func set_target_possess(body: CharacterBody2D):
	if possessing != null and body != possessing:
		unpossess()
		target_possess = body
		target_pos = body.global_position
	elif possessing == null:
		target_possess = body
		target_pos = body.global_position

func possess(body: CharacterBody2D):
	possessing = body
	target_possess = null
	fade_away()
	possessing.become_possessed()

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
