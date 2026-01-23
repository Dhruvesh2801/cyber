extends Panel

@export_enum("safe", "unsafe") var zone_type: String

func _can_drop_data(_position, data):
	#return data is Panel and data.has_method("get_action_index")
	return true

func _drop_data(_position, data):
	data.global_position = global_position + (size - data.size) / 2
	#get_parent().check_drop(data, zone_type)
	# Notify game controller
	SignalManager.card_dropped.emit(data, str(zone_type))
	print("DropData called")

func is_safe() -> bool:
	if zone_type =="safe":
		return true
	else:
		return false
