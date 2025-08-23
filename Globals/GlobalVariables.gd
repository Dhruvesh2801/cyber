extends Node

#naming
var player_name :String
func get_player_name() -> String:
	return player_name
func set_player_name(name: String):
	player_name = name

#Scoring
var player_score : int
func get_player_score() -> int:
	return player_score
func update_score(score: int):
	player_score += score
	
	
#Login
var isAdmin: bool
