extends CharacterBody2D

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

@export var gravity = 300
@export var speed = 80
var direction = 1
var is_sad = false

func _ready() -> void:
	ponder_sadly()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if not is_sad:
		velocity.x = speed * direction
		if not is_on_floor():
			velocity.x/=2
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
		if Input.is_action_pressed("jump") && is_on_floor() && not is_sad:
			velocity.y = -250

func _on_side_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("Walls"):
		ponder_sadly()
		direction = -direction
		print("Collided with wall!")
		

func ponder_sadly():
	is_sad = true
	velocity.x = 0
	animator.play("Idle")
	timer.start()

func _on_timer_timeout() -> void:
	is_sad = false
	velocity.x = speed
	animator.play("Walking")
