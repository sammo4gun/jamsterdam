extends Node2D

@onready var Ghost = $"Ghost"
@onready var pause_menu = $PauseMenu
@onready var Guy = $"Guy"
@onready var RestartLabel = $"CanvasLayer/RestartLabel"
@onready var AdviceLabel = $"CanvasLayer/YouShouldRestartLabel"
@onready var mainmusic = $"MusicPlayer"
@onready var endmusic = $"EndMusicPlayer"
@onready var deadmusic = $"DeadMusicPlayer"

var RESTART_TIME = 2.0
var restart = 0.0
var guy_dead = false

var time = 0
@onready var basepos = AdviceLabel.position

func _process(delta: float) -> void:
	if guy_dead:
		time += delta
		AdviceLabel.position.y = basepos.y + sin(time * 1.5) * 6
	if Input.is_action_pressed("restart"):
		restart += delta
	else: restart = 0.0
	
	RestartLabel.modulate[3] = min(1, (restart - RESTART_TIME/4)/(RESTART_TIME/2))
	
	if restart >= RESTART_TIME or (guy_dead and restart > 0):
		# Reset Scene
		get_tree().reload_current_scene()

func next_level():
	var current_name = get_tree().current_scene.name

	# Use regex to extract digits from the name
	var regex = RegEx.new()
	regex.compile(r"\d+")
	var result = regex.search(current_name)

	if result:
		var number = int(result.get_string())
		var next_number = number + 1
		var next_scene_path = "res://Scenes/Levels/level%d.tscn" % next_number
		get_tree().change_scene_to_file(next_scene_path)
	else:
		print("No number found in scene name")

func attempt_possession(body: Moveable):
	Ghost.set_target_possess(body)

func go_scare(body):
	Ghost.set_target_scare(body)

func level_completed():
	mainmusic.stop()
	await get_tree().create_timer(1.3).timeout
	endmusic.play()

func guy_died():
	mainmusic.stop()
	await get_tree().create_timer(0.3).timeout
	deadmusic.play()
	AdviceLabel.visible = true
	guy_dead = true

func _on_background_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Ghost.set_target_pos(event.global_position)

func get_guy():
	return Guy
