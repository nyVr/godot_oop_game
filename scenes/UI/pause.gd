extends Control

# pause func, pressing buttons

func _ready():
	$bg.show()
	$MarginContainer.show()
	$volumeSliders.hide()

func _on_quit_pressed():
	get_tree().quit()


func _on_controls_pressed():
	pass # Replace with function body.


func _on_volume_pressed():
	$bg.hide()
	$MarginContainer.hide()
	$volumeSliders.show()


func _on_back_vol_pressed():
	$volumeSliders.hide()
	$bg.show()
	$MarginContainer.show()
