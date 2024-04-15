extends Control



# restart the current scene
func _on_button_pressed():
	get_tree().change_scene_to_file(Global.current_scene)


func _on_quit_pressed():
	get_tree().quit()


func _on_mainmenu_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/mainMenu.tscn")
