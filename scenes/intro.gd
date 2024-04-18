extends Node3D
# manually matching cutscene with mc animation
var animqueue = ["cutsceneP1", "cutsceneP2"]
var mcanimqueue = ["look_up", "[stop]"]

# array vars for iteration
var index = 0
var maxindex = animqueue.size()

func _ready():
	play_nims()

# queue for animations
func play_nims():
	$cutscene.play(animqueue[index])
	$mainchar/AnimationPlayer.play(mcanimqueue[index])

## signal
func _on_cutscene_animation_finished(anim_name):
	index += 1
	# reached end of animaiton queue
	if index < maxindex:
		play_nims()
