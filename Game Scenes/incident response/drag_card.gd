extends Panel
@onready var card_text: Label = $card_text
var start_position: Vector2
@export var action_index: int

func _get_drag_data(_position):
	var preview = duplicate()
	preview.modulate.a = 0.8
	set_drag_preview(preview)
	return self
	
func set_text(text: String)-> void:
	card_text.text = text
	pass

func _ready():
	start_position = global_position

func get_action_index() -> int:
	return action_index
