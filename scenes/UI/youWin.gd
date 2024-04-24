extends Control






func _on_mainmenu_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/mainMenu.tscn")


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://scenes/intro.tscn")


func _on_quit_pressed():
	get_tree().quit()
