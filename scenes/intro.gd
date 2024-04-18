extends Node3D

func _ready():
	$cutscene.play("cutsceneP1")
	$mainchar/AnimationPlayer.play("look_up")
	

func play_nims():
	pass
