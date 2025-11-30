extends CanvasLayer

@export_file("*.json") var d_file: String
@onready var player_name: RichTextLabel = $NinePatchRect/Name
@onready var chat: RichTextLabel = $NinePatchRect/Chat
@export var typing_speed: float = 0.01
@onready var next_button: TextureButton = $NextButton
@onready var typing__lanel: Label = $Typing__lanel #debug
@export var punctuation_delay: int = 4
@onready var robot: AnimatedSprite2D = $Robot
@onready var next: Label = $NextButton/Next
@onready var back_button: TextureButton = $BackButton


var dialogue: Array = []
var current_dialogue_id: int = -1
var d_Active: bool = false
var typing: bool = false  # To prevent skipping during animation

func _process(delta: float) -> void:
	if typing:
		next_button.hide()
		back_button.hide()
		typing__lanel.text = "Typing" #debug
		robot.speak()
	else:
		next_button.show()
		back_button.show()
		typing__lanel.text = "NOT Typing" #debug
		robot.stop_speak()


func _ready() -> void:
	player_name.clear()
	chat.clear()
	start()
	
func start():
	dialogue = load_dialogue()
	await type_text(dialogue[current_dialogue_id].get("name", ""), player_name)
	next_script()

func load_dialogue() -> Array:
	if not FileAccess.file_exists(d_file):
		push_error("Dialogue file not found: " + d_file)
		return []

	var file := FileAccess.open(d_file, FileAccess.READ)
	var content := file.get_as_text()
	var result = JSON.parse_string(content)
	
	if result is Array:
		return result
	else:
		push_error("Invalid JSON format: Expected an Array")
		return []

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not typing:
		next_script()

func next_script() -> void:
	current_dialogue_id += 1
	if current_dialogue_id < dialogue.size():
		#player_name.clear()
		chat.clear()
		#if the last text is reached, the next button changes to close button
		if current_dialogue_id == dialogue.size() -1:
			next.text = "CLOSE"
		await type_text(dialogue[current_dialogue_id].get("text", ""), chat)
	else:
		print("End of dialogue") #debug
		SignalManager.DialogueEnded.emit()
		#since the last text is reached, the close button is displayed and when clicked, 
		#the interface hides itself displaying the main scne
		hide()

func type_text(text: String, label: RichTextLabel) -> void:
	typing = true
	label.clear()
	for i in text.length():
		label.append_text(text[i])
		var char: String = text[i]
		var delay: float = typing_speed
		if char =="." or char == ",":
			delay *= punctuation_delay
		await get_tree().create_timer(delay).timeout
	typing = false

#moves back 1 up in dalogue
func prev_script() -> void:
	if current_dialogue_id >0:
		current_dialogue_id -= 1
	if current_dialogue_id < dialogue.size():
		#player_name.clear()
		chat.clear()
		#if the last text is reached, the next button changes to close button
		if current_dialogue_id == dialogue.size() -1:
			next.text = "CLOSE"
		await type_text(dialogue[current_dialogue_id].get("text", ""), chat)
	else:
		print("End of dialogue") #debug
		#since the last text is reached, the close button is displayed and when clicked, 
		hide()


func _on_next_button_pressed() -> void:
	if not typing:
		next_script()
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	if not typing:
		prev_script()
	pass # Replace with function body.
