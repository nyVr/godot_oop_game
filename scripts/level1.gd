extends Node3D

var isPaused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/Pause.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func _input(event):
	if event.is_action_pressed("esc"):
		if isPaused:
			print("***UNPAUSE***")
			unpause()
		else:
			print("***PAUSE***")
			pause()
	else:
		pass
		
func pause():
	isPaused = true
	Engine.time_scale = 0
	$CanvasLayer/Pause.show()
	

func unpause():
	isPaused = false
	Engine.time_scale = 1
	$CanvasLayer/Pause.hide()
