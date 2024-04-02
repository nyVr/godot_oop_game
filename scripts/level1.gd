extends Node3D

class_name Level1

@onready var player = $joe

@onready var enemyScene : PackedScene = preload("res://scenes/enemy.tscn")





# $enemy
func _physics_process(_delta):
	get_tree().call_group("enemy", "updatePlayerLocation", player.global_transform.origin)

# Called when the node enters the scene tree for the first time.
func _ready():
	inst(Vector3(6, 0.5, 2))
	inst(Vector3(3, 0.5, 2))
	inst(Vector3(2, 0.5, 2))
	inst(Vector3(9, 0.5, 2))
	

	$CanvasLayer/Pause.hide()
	

# instantiate enemies
func inst(pos):
	var enemy = enemyScene.instantiate()
	enemy.position = pos
	add_child(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		if Global.isPaused:
			print("***UNPAUSE***")
			unpause()
		else:
			print("***PAUSE***")
			pause()
	
	else:
		pass

func _input(_event):
	pass
		
func _on_resume_press():
	if Global.isPaused:
		Global.isPaused = false
		Engine.time_scale = 1
		get_tree().paused = false
		$CanvasLayer/Pause.hide()
	else:
		pass
	
		
# stop game time when ESC pressed
# using engine.time_scale because if use get_tree().pause = true then processing
# will stop and can no longer detect input, meaning pause never be unpaused
func pause():
	Global.isPaused = true
	Engine.time_scale = 0
	get_tree().paused = true
	$CanvasLayer/Pause.show()

# start the time when ESC pressed again
func unpause():
	Global.isPaused = false
	Engine.time_scale = 1
	get_tree().paused = false
	$CanvasLayer/Pause.hide()
