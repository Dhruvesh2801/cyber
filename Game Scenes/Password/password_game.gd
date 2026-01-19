extends Control

@export_file("*.json") var e_file: String
var password_data: Array = []  # Will store the whole JSON array
@onready var dialogue: CanvasLayer = $Dialogue
@onready var block_click: Control = $block_click
@onready var pw_1: Button = $PW1
@onready var pw_2: Button = $PW2
@onready var pw_3: Button = $PW3
@onready var current_pw: Label = $current_pw


@onready var tip: Label = $tip_panel/tip
@onready var tip_panel: Panel = $tip_panel

var correct_pw_index: int
var tip1: String
var tip2: String
var tip3: String
var tips: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue.show()
	block_click.show()
	SignalManager.DialogueEnded.connect(game_start)
	password_data = load_passwords()
	tip_panel.hide()
	
	if password_data.is_empty():
		push_error("No passwords loaded")
	else:
		print("Loaded %d passwords" % password_data.size())
	show_password()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_start()-> void:
	block_click.hide()
	pass

func load_passwords()-> Array:
	if not FileAccess.file_exists(e_file):
		push_error("Email file not found: " + e_file)
		return []
		
	var file = FileAccess.open(e_file, FileAccess.READ)
	var content := file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(content)
	if result is Array:
		#pick a random 15 mails
		result.shuffle()
		return result.slice(0, 15)
	else:
		push_error("Invalid JSON format: Expected an Array")
		return []
	
func show_password() -> void:
	if password_data.is_empty():
		print("No more emails left!")
		return
	randomize()
	var index = randi() % password_data.size()
	var password = password_data[index]
	password_data.remove_at(index)
	
	pw_1.text = password["options"][0]
	pw_2.text = password["options"][1]
	pw_3.text = password["options"][2]
	tip1 = password["feedback"][0]
	tip2 = password["feedback"][1]
	tip3 = password["feedback"][2]
	tips = password["feedback"]
	current_pw.text = password["current_password"]
	correct_pw_index = password["correct_index"]
	pass
	
func check_answer(ans: int) ->void:
	var tip = tips[ans]
	if ans == correct_pw_index:
		display_tip(tip)
		show_password()
	else:
		display_tip(tip)
		await get_tree().create_timer(2).timeout
		show_password()
	pass

func display_tip(text:String) ->void:
	tip.text = text
	tip_panel.show()
	block_click.show()
	await get_tree().create_timer(2).timeout
	tip_panel.hide()
	block_click.hide()
func _on_pw_1_pressed() -> void:
	check_answer(0)
func _on_pw_2_pressed() -> void:
	check_answer(1)
func _on_pw_3_pressed() -> void:
	check_answer(2)
