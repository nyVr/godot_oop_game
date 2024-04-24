extends Node3D

@onready var mcPlayer = $mainchar/AnimationPlayer
@onready var cutscenePlayer = $cutscene


# manually matching cutscene with mc animation
var animqueue = ["cutsceneP1", "cutsceneP3", "cutsceneP4"]
var mcanimqueue = ["look_up", "run", "crouch_look_down"]

# array vars for iteration
var index = 0
var maxindex = animqueue.size()

func _ready():
	play_nims()

# queue for animations
func play_nims():
	cutscenePlayer.play(animqueue[index])
	if mcanimqueue[index] != "[stop]":
		mcPlayer.play(mcanimqueue[index])
	else:
		return

## signal
func _on_cutscene_animation_finished(anim_name):
	index += 1
	# reached end of animaiton queue
	if index < maxindex:
		play_nims()
	if anim_name == "cutsceneP4":
		get_tree().change_scene_to_file("res://scenes/level1.tscn")
