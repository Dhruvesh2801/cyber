extends Control
@onready var _answer: Label = $Answer #debug
@onready var _tip: Label = $TipsPanel/Tip
@onready var tips_panel: Panel = $TipsPanel

@export_file("*.json") var e_file: String
var email_data: Array = []  # Will store the whole JSON array
@onready var from_text: Label = $EmailPanel/EmailContainer/VBoxContainer/FromContainer/Panel2/MarginContainer/FromText
@onready var subject_text: Label = $EmailPanel/EmailContainer/VBoxContainer/SubjectContainer/Panel2/MarginContainer/SubjectText
@onready var body_text: RichTextLabel = $EmailPanel/EmailContainer/VBoxContainer/BodyContainer/Panel2/MarginContainer/BodyText
@onready var hover_panel: Panel = $HoverPanel
@onready var hover_label: Label = $HoverPanel/HoverLabel
@onready var card: card = $Card
@onready var block_click: Control = $block_click


@onready var timer_label: Label = $TimerPanel/TimerLabel
@onready var timer: Timer = $Timer
var total_time: int
var max_time = 20


var current_email_phish: bool
var current_tip: String

var max_score: int = 20
var score: int
var total_score: int






func _ready() -> void:
	total_time = 0
	timer.wait_time = 1.0
	timer.start()
	
	
	
	block_click.hide()
	body_text.connect("meta_hover_started", Callable(self, "_on_link_hover_start"))
	body_text.connect("meta_hover_ended", Callable(self, "_on_link_hover_end"))
	body_text.connect("meta_clicked", Callable(self, "_on_link_click"))
	
	hover_panel.visible = false
	
	tips_panel.hide()
	# Load JSON once at scene start
	email_data = load_email()
	
	if email_data.is_empty():
		push_error("No email data loaded.")
	else:
		print("Loaded %d emails" % email_data.size())
		show_random_email()
		
		
func _process(delta: float) -> void:
	timer_label.text = str(total_time)
	pass	
	




func load_email() -> Array:
	if not FileAccess.file_exists(e_file):
		push_error("Email file not found: " + e_file)
		return []
	
	var file = FileAccess.open(e_file, FileAccess.READ)
	var content := file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(content)
	if result is Array:
		for email in result:
			#use the name input by the player
			email["body"] = email["body"].replace("{name}", GlobalVariables.player_name)
			
		#pick a random 15 mails
		result.shuffle()
		return result.slice(0, 15)
	else:
		push_error("Invalid JSON format: Expected an Array")
		return []

func show_random_email():
	if email_data.is_empty():
		print("No more emails left!")
		return
	
	randomize()
	var index = randi() % email_data.size()
	var email = email_data[index]
	
	# Remove it so it can't be picked again
	email_data.remove_at(index)
	
	from_text.text = email["from"]
	subject_text.text = email["subject"]
	body_text.bbcode_text  = email["body"]
	current_email_phish = email["phishing"]
	current_tip = "TIP:\n" +email["tip"]

func check_answer(answer: bool):
	
	score  = max_score - total_time
	
	if answer == current_email_phish:
		card.show_card(true)
		block_click.show()
		timer.stop()
		await get_tree().create_timer(0.5).timeout
		total_time = 0
		timer.start()
		block_click.hide()
		show_random_email()
		total_score +=score
	else:
		_tip.text = current_tip
		card.show_card(false)
		tips_panel.show()
		block_click.show()
		timer.stop()
		await get_tree().create_timer(5).timeout
		total_time = 0
		timer.start()
		block_click.hide()
		tips_panel.hide()
		show_random_email()
		
	_answer.text = str(total_score)
	pass

func _on_next_pressed() -> void:
	show_random_email()
	_answer.text = ""
	_tip.text = ""

	

func _on_legit_button_pressed() -> void:
	check_answer(false)
	pass # Replace with function body.


func _on_phish_button_pressed() -> void:
	check_answer(true)
	pass # Replace with function body.
	
func _on_link_hover_start(meta):
	# meta contains the URL
	hover_label.text = meta
	
	
	var padding = Vector2(20, 20)  # optional padding inside the panel
	#hover_panel.rect_size = hover_label.get_minimum_size() + padding
	hover_panel.visible = true
	
	# Optional: position the card near mouse
	hover_panel.global_position = get_global_mouse_position() + Vector2(10, 10)

func _on_link_hover_end(meta):
	hover_panel.visible = false

func _on_link_click(meta):
	OS.shell_open(meta)  # opens URL in default browser


func _on_timer_timeout() -> void:
	total_time += 1
	timer_label.text = str(total_time)
	
	if total_time >= max_time:
		_tip.text = current_tip
		timer.stop()
		block_click.show()
		tips_panel.show()
		await get_tree().create_timer(5).timeout
		total_time = 0
		timer.start()
		block_click.hide()
		tips_panel.hide()
		show_random_email()
	pass # Replace with function body.
