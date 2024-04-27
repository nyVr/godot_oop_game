extends Control

# display pages
# whennext clicked display next page
# when prev clicked display prev page
# when skip clicked skip to level

@onready var pages = [$page1, $page2, $page3, $page4, $page5]
@onready var amt = pages.size()
@onready var currIndex = 0

func _ready():
	update_btn_visibility()
	$music.play()


## BUTTONS PRESSED


func _on_next_pressed():
	if currIndex < (amt-1):
		currIndex += 1
		update_btn_visibility()


func _on_prev_pressed():
	if currIndex > 0:
		currIndex -= 1
		update_btn_visibility()


func _on_skip_pressed():
	if currIndex < (amt-1):
		get_tree().change_scene_to_file("res://scenes/level2.tscn")


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/level2.tscn")


# 
func update_btn_visibility():
	# hide all btns 
	$play.hide()
	$next.hide()
	$prev.hide()
	$skip.hide()
	
	# show approproate btn
	if currIndex == 0:
		$next.show()
		$skip.show()
	elif currIndex == (amt - 1):
		$prev.show()
		$play.show()
	else:
		$next.show()
		$prev.show()
		$skip.show()
	
	# show curr page
	for i in range(amt):
		if i == currIndex:
			pages[i].show()
		else:
			pages[i].hide()


