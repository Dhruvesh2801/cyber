extends Node

#naming
var player_name :String
func get_player_name() -> String:
	return player_name
func set_player_name(name: String):
	player_name = name

var session_id :String
func get_session_id() -> String:
	return session_id
func set_session_id(session: String):
	session_id = session


#Scoring
var player_score : int
func get_player_score() -> int:
	return player_score
func update_score(score: int):
	player_score += score
	
	
#Login
var isAdmin: bool

#Play_mode
var is_campaign: bool = false


#Score Manager
var session_data := {} 
var all_sessions := []  # Array of all sessions (loaded from JSON)
var json_file_path := "user://scores.json" # Use user:// for writable data


func _ready():
	# Load data ONCE when the game starts
	all_sessions = load_sessions()
	print("Game ready. Loaded existing sessions: ", all_sessions.size())


func start_session(player_name: String, session_id: String) -> void:
	session_data = {
		"session_id": session_id,
		"name": player_name,
		"game1_score": 0,
		"game2_score": 0,
		"game3_score": 0,
		"game4_score": 0,
		"game5_score": 0
	}
	# Scores are updated later during gameplay.


func load_sessions() -> Array:
	if not FileAccess.file_exists(json_file_path):
		return []
	var file := FileAccess.open(json_file_path, FileAccess.READ)
	var content := file.get_as_text()
	file.close()
	
	# Use JSON.parse_string for Godot 4
	var result = JSON.parse_string(content) 
	if result == null or typeof(result) != TYPE_ARRAY:
		# Handle cases where the file might exist but contain invalid JSON or an empty string
		return []
	return result


# Use this function when the current session is finalized and ready to be saved
func save_current_session_to_file() -> void:
	# Add the currently active session dictionary to the list of all sessions in memory
	all_sessions.append(session_data)
	
	# Convert the entire Godot Array (all_sessions) into a single JSON string
	var json_string := JSON.stringify(all_sessions, "\t")
	
	# Open the file in WRITE mode, which overwrites the entire existing file
	var file := FileAccess.open(json_file_path, FileAccess.WRITE)
	
	if file:
		# Store the full JSON string in the file
		file.store_string(json_string)
		
		# Close the file to ensure data is written to disk
		file.close()
		print("Successfully saved all sessions to disk.")
	else:
		print("Error saving file: ", FileAccess.get_open_error())
