extends Control
class_name card
@onready var panel: Panel = $Panel
const CORRECT = preload("res://dialogue/asset/Correct.png")
const WRONG = preload("res://dialogue/asset/Wrong.png")
@onready var logo: TextureRect = $Panel/logo

var stylebox: StyleBoxFlat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stylebox = panel.get_theme_stylebox("panel")
	logo.scale = Vector2(0.5,0.5)
	hide()
	pass

func animate_logo() -> void:
	var tween1 = create_tween()
	tween1.set_parallel(true)
	tween1.tween_property(panel,"modulate:a", 0, 0.5)
	tween1.tween_property(logo,"scale", Vector2(1,1), 0.5)
	tween1.finished.connect(func(): hide(), CONNECT_ONE_SHOT) # hide after fade

func show_card(answer: bool):
	show()
	if answer ==true:
		stylebox.border_color = Color.GREEN
		logo.texture = CORRECT
		
	else:
		stylebox.border_color = Color.RED
		logo.texture = WRONG
		
	panel.modulate.a = 1
	logo.scale = Vector2(0.5,0.5)
	animate_logo()
