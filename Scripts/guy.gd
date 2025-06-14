extends CharacterBody2D

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var death_sound: AudioStreamPlayer = $DeathSound
@onready var world = get_parent()

@export var gravity = 300
@export var speed = 80
@export var out_of_bounds_y = 800
@export var jump_strength = 250

var direction = 1
var is_sad = false
var scared_time = 1

func _ready() -> void:
	ponder_sadly()

func _physics_process(delta):
	if position.y > out_of_bounds_y:
		die_and_reset()
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	if not is_sad:
		velocity.x = speed * direction
	if is_sad and is_on_floor(): 
		velocity.x = 0
	if is_sad and not is_on_floor():
		velocity.x = speed * direction / 3.0
	if scared_time > 0:
		scared_time -= delta
		velocity.x /= 2
	move_and_slide()

func ponder_sadly():
	is_sad = true
	animator.play("Idle")
	timer.start()

func _on_timer_timeout() -> void:
	is_sad = false
	velocity.x = speed
	animator.play("Walking")

func die_and_reset():
	# Prevent re-entering if already dying
	set_physics_process(false)
	
	# Stop movement
	velocity = Vector2.ZERO

	# Play death sound
	death_sound.play()
	
	# Wait a bit (e.g. 1 second), then reset the scene
	await get_tree().create_timer(1.0).timeout
	
	# Reset Scene
	get_tree().reload_current_scene()

func frighten():
	if is_on_floor():
		velocity.y = -jump_strength
		scared_time = 1.5
		return true
	else:
		return false

func _on_left_side_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("Walls"):
		if direction > 0:
			ponder_sadly()
			direction = -direction

func _on_right_side_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("Walls"):
		if direction < 0:
			ponder_sadly()
			direction = -direction

func _on_input_event(viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	viewport.set_input_as_handled()
	if event is InputEventMouseButton and event.pressed:
		world.go_scare(self)
