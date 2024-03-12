extends Node3D

var isPaused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/Pause.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("esc"):
		if isPaused:
			print("***UNPAUSE***")
			unpause()
		else:
			print("***PAUSE***")
			pause()
	else:
		pass
		

func _input(event):
	pass
	#if event.is_action_pressed("esc"):
		#if isPaused:
			#print("***UNPAUSE***")
			#unpause()
		#else:
			#print("***PAUSE***")
			#pause()
	#else:
		#pass
		
# stop game time when ESC pressed
# using engine.time_scale because if use get_tree().pause = true then processing
# will stop and can no longer detect input, meaning pause never be unpaused
func pause():
	isPaused = true
	Engine.time_scale = 0
	$CanvasLayer/Pause.show()

# start the time when ESC pressed again
func unpause():
	isPaused = false
	Engine.time_scale = 1
	$CanvasLayer/Pause.hide()
