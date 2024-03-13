extends Control

class_name pause

signal resume_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("resume_pressed", self, "_on_resume_press")
	#var scene_tree = get_tree()
#
	## Get the current scene
	#var current_scene = scene_tree.get_current_scene()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit()

func _on_resume_pressed():
	#emit_signal("resume_pressed")
	pass
