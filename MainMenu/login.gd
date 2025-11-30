extends Control
var _player_name: String
var _session_id: String
@onready var name_input: LineEdit = $User/NameInput
@onready var ok_button: Button = $User/OkButton
@onready var user: Control = $User
@onready var admin: Control = $Admin
@onready var adm_name_input: LineEdit = $Admin/AdmNameInput
@onready var adm_password_input: LineEdit = $Admin/AdmPasswordInput




var users = {
	"admin": "admin",
	"player": "password"
}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	user.show()
	admin.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_ok_button_pressed() -> void:
	if name_input.text.is_empty():
		name_input.placeholder_text = "Please Enter your Name"
	else:
		_player_name = name_input.text.strip_edges() # removes whitescpace
		_session_id = create_session_id(_player_name)
		GlobalVariables.set_player_name(_player_name)
		GlobalVariables.set_session_id(_session_id)
		GlobalVariables.isAdmin = false
		GlobalVariables.start_session(_player_name,_session_id)

		get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")

	pass # Replace with function body.


func _on_user_2_admin_pressed() -> void:
	user.hide()
	admin.show()
	pass # Replace with function body.


func _on_admin_2_user_pressed() -> void:
	user.show()
	admin.hide()
	pass # Replace with function body.


func _on_adm_ok_button_pressed() -> void:
	var username = adm_name_input.text
	var password = adm_password_input.text
	if users.has(username) and users[username] == password:
		GlobalVariables.isAdmin = true
		GlobalVariables.set_player_name(username)
		get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	
	else:
		adm_password_input.add_theme_color_override("bg_color",Color.RED)
		pass
	pass # Replace with function body.

func create_session_id(player_name: String) -> String:
	var dt = Time.get_datetime_dict_from_system()
	#year, month, day, weekday, hour, minute, second,
	var year = dt["year"]
	var month = dt["month"]
	var day = dt["day"]
	var hour = dt["hour"]
	var minute = dt["minute"]
	var second = dt["second"]
	var timestamp = str(year)+str(month)+str(day)+str(hour)+str(minute)+str(second)
	return player_name+"_"+timestamp
