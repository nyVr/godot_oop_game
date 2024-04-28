extends Control

# pause func, pressing buttons

func _ready():
	$bg.show()
	$MarginContainer.show()
	$volumeSliders.hide()

func _on_quit_pressed():
	get_tree().quit()


func _on_controls_pressed():
	$controlMenu.show()
	$bg.hide()
	$MarginContainer.hide()

func _on_volume_pressed():
	$bg.hide()
	$MarginContainer.hide()
	$volumeSliders.show()


func _on_back_vol_pressed():
	$volumeSliders.hide()
	$bg.show()
	$MarginContainer.show()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/mainMenu.tscn")


func _on_back_cntrl_pressed():
	$controlMenu.hide()
	$bg.show()
	$MarginContainer.show()
	


func _on_fullsc_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

