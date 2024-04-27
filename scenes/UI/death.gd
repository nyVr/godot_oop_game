extends Control


func _ready():
	var score_text = "Score: " + str(Global.endlessStarCount)
	$MarginContainer/VBoxContainer/score.text = score_text
	Global.endlessStarCount = 0
	$bgMusic.play()


# restart the current scene
func _on_button_pressed():
	get_tree().change_scene_to_file("res://mapGen/map.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_mainmenu_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/mainMenu.tscn")
