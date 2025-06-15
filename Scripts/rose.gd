extends Area2D

@onready var sprite = $"Rose"
var basepos
var time = 0

func _ready():
	self.body_entered.connect(_on_body_entered)
	basepos = sprite.position

func _process(delta: float) -> void:
	time += delta
	sprite.position.y = basepos.y + sin(time * 1.5) * 6

func _on_body_entered(body):
	if body.is_in_group("Guy"):
		get_parent().level_completed()
		body.find_hope()
