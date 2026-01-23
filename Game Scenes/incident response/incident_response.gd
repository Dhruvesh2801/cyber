extends Control
@onready var scenario_text: Label = $Main/MarginContainer5/Panel/scenario_text

@export_file("*.json") var e_file: String
@onready var draggable_card_1: Panel = $Main/MarginContainer/draggable_card1
@onready var draggable_card_2: Panel = $Main/MarginContainer2/draggable_card2
@onready var draggable_card_3: Panel = $Main/MarginContainer3/draggable_card3
@onready var draggable_card_4: Panel = $Main/MarginContainer4/draggable_card4
@onready var block_click: Control = $block_click
@onready var dialogue: CanvasLayer = $Dialogue


var password_data: Array = []  # Will store the whole JSON array

@onready var final_score_panel: Panel = $FinalScorePanel
@onready var final_score_text: Label = $FinalScorePanel/Score/FinalScoreText
@onready var retry: Button = $FinalScorePanel/retry
@onready var main_menu: Button = $FinalScorePanel/main_menu
@onready var next_level: Button = $FinalScorePanel/next_level

var feedback1 :String
var feedback2 :String
var feedback3 :String
var feedback4 :String
var total_score: int

#Cards logic
var correct_actions: Array
var wrong_actions: Array
var placed_actions := []
var total_actions: int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("game_controller")
	SignalManager.DialogueEnded.connect(game_start)
	SignalManager.card_dropped.connect(check_drop) # <--- connect here
	block_click.show()
	dialogue.show()
	password_data = load_passwords()
	draggable_card_1.set_text("set text")
	show_password()
	pass # Replace with function body.

@onready var test_score: Label = $Main/test_score

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	test_score.text = str(total_score)
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
	scenario_text.text = password["context"]
	draggable_card_1.set_text( password["actions"][0])
	draggable_card_1.action_index = 0
	feedback1 = password["feedback"][0]
	draggable_card_2.set_text( password["actions"][1])
	draggable_card_2.action_index = 1
	feedback2 = password["feedback"][1]
	draggable_card_3.set_text( password["actions"][2])
	draggable_card_3.action_index = 2
	feedback3 = password["feedback"][2]
	draggable_card_4.set_text( password["actions"][3])
	draggable_card_4.action_index = 3
	feedback4 = password["feedback"][3]
	
	correct_actions = password["correct_actions"].map(func(a): return int(a))
	print(correct_actions)
	wrong_actions = password["wrong_actions"].map(func(a): return int(a))
	placed_actions.clear()
	total_actions = wrong_actions.size() + correct_actions.size()
	
	for card in [
	draggable_card_1,
	draggable_card_2,
	draggable_card_3,
	draggable_card_4
]:
		card.set_process_input(true)
		card.modulate = Color.WHITE
		card.global_position = card.start_position+ Vector2(10,10)
	
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

func check_drop(card, zone_type: String) -> void:
	print ("Card Dropped")
	var idx = card.action_index

	# Prevent double counting
	if idx in placed_actions:
		return

	if zone_type == "safe" and idx in correct_actions:
		handle_correct(card)
	elif zone_type == "unsafe" and idx in wrong_actions:
		handle_correct(card)
	else:
		handle_wrong(card)
	print("Card", card.action_index, "dropped into", zone_type)	
func handle_correct(card):
	print("correct")
	SoundManager.play_sound("correct")
	placed_actions.append(card.action_index)

	card.set_process_input(false) # lock card
	card.modulate = Color(0.7, 1.0, 0.7) # green tint

	#show_feedback(card.action_index)
	print ("ACTIONS: "+str(placed_actions.size()))
	check_completion()

func handle_wrong(card):
	print("wrong")
	SoundManager.play_sound("wrong")
	#show_feedback(card.action_index)
	card.global_position = card.start_position + Vector2(10,10)

func check_completion():
	if placed_actions.size() == total_actions:
		total_score += 15
		await get_tree().create_timer(1.0).timeout
		show_password()
	
