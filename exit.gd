extends Control
@onready var exit: MarginContainer = $CanvasLayer/Exit
@onready var exit_confirmation: MarginContainer = $CanvasLayer/ExitConfirmation

@onready var bg_col: ColorRect = $CanvasLayer/BGCol

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_col.visible = false
	exit_confirmation.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_expand_pressed() -> void:
	exit.hide()
	bg_col.visible = true
	exit_confirmation.show()
	pass # Replace with function body.


func _on_no_confirm_pressed() -> void:
	exit.show()
	exit_confirmation.hide()
	bg_col.visible = false
	pass # Replace with function body.


func _on_yes_confirm_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	pass # Replace with function body.
