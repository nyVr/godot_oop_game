extends Control


func _ready():
	$volumeSliders.hide()
	$sprite.show()
	$MarginContainer.show()


func _on_volume_pressed():
	$volumeSliders.show()
	$sprite.hide()
	$MarginContainer.hide()


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/mainMenu.tscn")


func _on_back_vol_pressed():
	$volumeSliders.hide()
	$sprite.show()
	$MarginContainer.show()
