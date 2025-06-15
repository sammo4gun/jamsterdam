extends CharacterBody2D

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var world = get_parent()
@onready var feet = $"Feet"

@export var gravity = 300
@export var speed = 80
@export var out_of_bounds_y = 800
@export var jump_strength = 250

var direction = 1
var is_sad = false
var first_ponder = true
var has_hope = false

var scared_time = 0;
var airtime = 0.0;
var on_floor = true;

func _ready() -> void:
	ponder_sadly()
	animator.flip_h = false

func _physics_process(delta):
	if not has_hope:
		for b in $"LeftSideCollision".get_overlapping_bodies():
			if velocity.y < delta * gravity:
				check_collision(b, -1)
		for b in $"RightSideCollision".get_overlapping_bodies():
			if velocity.y < delta * gravity:
				check_collision(b, 1)
		
		if position.y > out_of_bounds_y:
			die_and_reset()
			return
		
		for b in feet.get_overlapping_bodies():
			if b.is_in_group("Walls"):
				on_floor = true
				break
			on_floor = false
		if is_on_floor() or on_floor:
			if is_sad:
				velocity.x = 0
			else:
				velocity.x = speed * direction
				animator.play("Walking")
				airtime = 0.0
		else:
			velocity.y += gravity * delta
			if not is_sad:
				velocity.x = speed * direction / 2.0
			if scared_time > 0.0:
				airtime += delta / 2
				velocity.x *= 1.8
			else: airtime += delta
			
			if airtime > 0.6 and airtime <= 1.0:
				animator.play('Startfall')
			elif airtime > 1.0:
				animator.play("Fall")
			
		if scared_time > 0.0:
			scared_time -= delta
			if scared_time <= 0.0 and airtime <= 0.6:
				animator.play("Walking")
	move_and_slide()

func ponder_sadly():
	is_sad = true
	animator.play("Idle")
	timer.start()

func _on_timer_timeout() -> void:
	is_sad = false
	velocity.x = speed
	animator.play("Walking")
	if  first_ponder:
		first_ponder = false
		return
	animator.flip_h = !animator.flip_h

func die_and_reset():
	# Prevent re-entering if already dying
	set_physics_process(false)
	world.guy_died()

func frighten():
	if (is_on_floor() or on_floor) and not has_hope:
		scared_time = 1.4
		animator.play("Frighten")
		velocity.y = -jump_strength
		return true
	else:
		return false

func find_hope():
	velocity.x = 0
	animator.play('FindHope')
	has_hope = true

func check_collision(body, d):
	if body.is_in_group("Walls"):
		if direction != d and not is_sad:
			ponder_sadly()
			direction = -direction

func _on_left_side_collision_body_entered(body: Node2D) -> void:
	check_collision(body, -1)

func _on_right_side_collision_body_entered(body: Node2D) -> void:
	check_collision(body, 1)

func _on_input_event(viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	viewport.set_input_as_handled()
	if event is InputEventMouseButton and event.pressed:
		world.go_scare(self)

func _on_animated_sprite_2d_animation_finished() -> void:
	if has_hope:
		get_parent().next_level()

func _on_feet_body_entered(body: Node2D) -> void:
	if body.is_in_group("Walls"):
		if not on_floor:
			on_floor = true
