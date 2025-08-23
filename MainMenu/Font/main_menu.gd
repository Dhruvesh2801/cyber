extends Control
@onready var main_buttons: VBoxContainer = $CenterContainer/MainButtons
@onready var levels_menu: VBoxContainer = $CenterContainer/LevelsMenu
@onready var title: Label = $Title
@onready var center_container: CenterContainer = $CenterContainer
@onready var center_container_adm: CenterContainer = $CenterContainer2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levels_menu.hide()
	main_buttons.show()
	if GlobalVariables.isAdmin ==false:
		center_container.show()
		center_container_adm.hide()
	else:
		center_container.hide()
		center_container_adm.show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_levels_pressed() -> void:
	main_buttons.hide()
	levels_menu.show()
	title.text = "Choose a Level"
	pass # Replace with function body.


func _on_back_pressed() -> void:
	main_buttons.show()
	levels_menu.hide()
	title.text = "CYBERGUARD"
	pass # Replace with function body.



func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

#region Level Buttons
func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Game Scenes/Phishing/phishing_game_main.tscn")
	pass # Replace with function body.

func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Game Scenes/test_pw2.tscn")
	pass # Replace with function body.

func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Game Scenes/test_pw3.tscn")
	pass # Replace with function body.

func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Game Scenes/test_pw4.tscn")
	pass # Replace with function body.

func _on_level_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Game Scenes/test_pw5.tscn")
	pass # Replace with function body.
#endregion
