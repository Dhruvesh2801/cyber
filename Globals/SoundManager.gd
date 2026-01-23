extends Node

var sfx_correct = preload("res://Resources/Sounds/correct.mp3")
var sfx_wrong = preload("res://Resources/Sounds/wrong.mp3")
var sfx_complete = preload("res://Resources/Sounds/complete.mp3")

var player: AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)

# Play a sound by name
func play_sound(sound_name: String):
	match sound_name:
		"correct":
			player.stream = sfx_correct
		"wrong":
			player.stream = sfx_wrong
		"complete":
			player.stream = sfx_complete
		_:
			return
	player.play()
