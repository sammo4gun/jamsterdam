extends CharacterBody2D

const GRAVITY = 9.8

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	move_and_slide()
