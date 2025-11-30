extends Control
@onready var score_container: VBoxContainer = $MarginContainer/ScoreContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_leaderboard()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func build_leaderboard_top10() -> Array:
	var sessions = GlobalVariables.load_sessions()
	var leaderboard: Array = []
	
	for s in sessions:
		var total = float(s.game1_score) + float(s.game2_score) +float(s.game3_score)+float(s.game4_score)+float(s.game5_score)
		leaderboard.append({
			"name":s.name,
			"session_id": s.session_id,
			"total_score": total
		})
		leaderboard.sort_custom(func(a, b): return a.total_score > b.total_score)
		if leaderboard.size() > 10:
			leaderboard = leaderboard.slice(0, 10)
	return leaderboard


func show_leaderboard():
	var lb = build_leaderboard_top10()
	
	for entry in lb:
		var label = Label.new()
		label.add_theme_color_override("font_color", Color.WHITE)
		label.add_theme_font_size_override("font_size", 20)
		label.add_theme_color_override("font_shadow_color", Color.BLACK)
		label.add_theme_constant_override("shadow_offset_x", 2)
		label.add_theme_constant_override("shadow_offset_y", 2)
		
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.text = "%s — %d" % [entry.name, entry.total_score]
		
		
		var panel = Panel.new()
		panel.custom_minimum_size = Vector2(0, 40)
		panel.add_theme_stylebox_override("panel", StyleBoxFlat.new())
		panel.get_theme_stylebox("panel").bg_color = Color(0.2, 0.2, 0.2, 0.8)

		
		panel.add_child(label)
		score_container.add_child(panel)
	pass
