extends Control

@onready var unlock_timer = $unlockTimer

var msg1 = false
var msg2 = false

func _ready():
	if Global.isPaused:
		Global.isPaused = false
		Engine.time_scale = 1
		get_tree().paused = false
	$unlockMsg.hide()
	$noSavedMsg.hide()
	$sprite.show()
	$buttons.show()
	$MMmusic.play()
	

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/intro.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/optionsMenu.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_endless_pressed():
	if Global.endlessUnlocked:
		get_tree().change_scene_to_file("res://mapGen/map.tscn")
	$unlockMsg.show()
	msg1 = true
	unlock_timer.wait_time = 2
	unlock_timer.start()


func _on_continue_pressed():
	if Global.current_scene != "null":
		get_tree().change_scene_to_file(Global.current_scene)
	$noSavedMsg.show()
	msg2 = true
	unlock_timer.wait_time = 2
	unlock_timer.start()

func _on_unlock_timer_timeout():
	unlock_timer.stop()
	if msg1:
		$unlockMsg.hide()
		msg1 = false
	if msg2:
		$noSavedMsg.hide()
		msg2 = false
	

func _on_leaderboard_pressed():
	pass # Replace with function body.
