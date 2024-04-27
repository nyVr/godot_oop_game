extends Control

var player_name

var score = randi_range(0,100)

@onready var leaderboard_scene = preload("res://addons/silent_wolf/Scores/Leaderboard.tscn")

func _on_submit_pressed():
	var input_txt = $playername.text
	player_name = input_txt
	
	SilentWolf.Scores.save_score(player_name, score)
	get_tree().change_scene_to_packed(leaderboard_scene)

