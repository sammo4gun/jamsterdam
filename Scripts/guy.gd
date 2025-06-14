extends CharacterBody2D

@export var gravity = 9.8
@export var speed = 1
var direction = 1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x += speed * direction
	move_and_slide()
	

func _on_side_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("Walls"):
		direction = -direction
		print("Collided with wall!")
