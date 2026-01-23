extends Control

@onready var card: MarginContainer = $Card


func _get_drag_data(at_position: Vector2) -> Variant:
	var preview = duplicate()
	preview.modulate.a = 0.8
	set_drag_preview(preview)
	return self

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	card = data
	
