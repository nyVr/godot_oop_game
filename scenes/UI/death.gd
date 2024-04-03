extends Control



# restart the current scene
func _on_button_pressed():
	get_tree().change_scene_to_file(Global.current_scene)
