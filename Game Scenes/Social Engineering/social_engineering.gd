extends Control

@export_file("*.json") var e_file: String
var password_data: Array = []  # Will store the whole JSON array
@onready var block_click: Control = $block_click
@onready var dialogue: CanvasLayer = $Dialogue
@onready var main_text: Label = $main/MarginContainer/main_text
@onready var tip_panel: Panel = $tip_panel
@onready var tip: Label = $tip_panel/tip

@onready var option_1: Button = $VBoxContainer/Option1
@onready var option_2: Button = $VBoxContainer/Option2
@onready var option_3: Button = $VBoxContainer/Option3

var correct_index: int
var total_score: int

@onready var final_score_text: Label = $FinalScorePanel/Score/FinalScoreText
@onready var retry: Button = $FinalScorePanel/retry
@onready var main_menu: Button = $FinalScorePanel/main_menu
@onready var next_level: Button = $FinalScorePanel/next_level
@onready var final_score_panel: Panel = $FinalScorePanel
@onready var context: Label = $main/Panel/context
var tips: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue.show()
	block_click.show()
	SignalManager.DialogueEnded.connect(game_start)
	password_data = load_passwords()
	final_score_panel.hide()
	if password_data.is_empty():
		push_error("No passwords loaded")
	else:
		print("Loaded %d passwords" % password_data.size())
	show_password()
	tip_panel.hide()
	pass # Replace with function body.


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
		return result.slice(0, 10)
	else:
		push_error("Invalid JSON format: Expected an Array")
		return []
func show_password() -> void:
	if password_data.is_empty():
		print("No more passwords left!")
		game_end()
		return
	randomize()
	var index = randi() % password_data.size()
	var password = password_data[index]
	password_data.remove_at(index)
	
	option_1.text = password["options"][0]
	option_2.text = password["options"][1]
	option_3.text = password["options"][2]

	tips = password["feedback"]
	main_text.text = password["attacker_line"]
	correct_index = password["correct_index"]
	context.text = password["context"]
	correct_index = password["correct_index"]
	pass

func game_end () ->void:
	final_score_text.text = str(total_score)
	final_score_panel.show()
	show_buttons()
func show_buttons():
	if GlobalVariables.is_campaign == true:
		retry.hide()
		main_menu.hide()
		next_level.show()
	else:
		retry.show()
		main_menu.show()
		next_level.hide()
	pass


func _on_option_1_pressed() -> void:
	check_answer(0)
	pass # Replace with function body.


func _on_option_2_pressed() -> void:
	check_answer(1)
	pass # Replace with function body.


func _on_option_3_pressed() -> void:
	check_answer(2)
	pass # Replace with function body.


func check_answer(ans: int) ->void:
	var tip = tips[ans]
	if ans == correct_index:
		total_score +=20
		show_password()
	else:
		display_tip(tip)

func display_tip(text:String) ->void:
	tip.text = text
	tip_panel.show()
	block_click.show()
	await get_tree().create_timer(2).timeout
	tip_panel.hide()
	block_click.hide()


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Game Scenes/Social Engineering/social_engineering.tscn")
	pass # Replace with function body.


func _on_main_menu_pressed() -> void:
	GlobalVariables.session_data["game3_score"] = total_score
	GlobalVariables.save_current_session_to_file()
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	pass # Replace with function body.


func _on_next_level_pressed() -> void:
	GlobalVariables.session_data["game3_score"] = total_score
	GlobalVariables.save_current_session_to_file()
	get_tree().change_scene_to_file("res://Game Scenes/Social Engineering/social_engineering.tscn")# to change this scene later.
	pass # Replace with function body.
