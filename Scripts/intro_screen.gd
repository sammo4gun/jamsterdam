extends Control

@onready var label0 = $Label0
@onready var label1 = $Label1
@onready var label2 = $Label2
@onready var label3 = $Label3
@onready var labels = {
	0: label0,
	1: label1,
	2: label2,
	3: label3
}
var max_label = 3

@onready var tooltip = $Tooltip

var label_at = 0
var fade_amount = 0
var time = 0

func _ready():
	for i in labels:
		labels[i].modulate[3] = 0

func _process(delta: float) -> void:
	time += delta
	for i in range(min(label_at + 1, max_label+1)):
		if i < label_at:
			labels[i].modulate[3] = 1
		else: 
			labels[i].modulate[3] = min(1, labels[i].modulate[3]+delta)

func start_game():
	var new_scene = load("res://Scenes/Levels/level1.tscn")  # Replace with your scene path
	get_tree().change_scene_to_packed(new_scene)

func _input(event):
	if event is InputEventKey and event.pressed:
		label_at += 1
	
	if label_at > max_label:
		start_game()
