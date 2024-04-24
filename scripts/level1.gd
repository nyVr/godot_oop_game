extends Node3D

class_name Level1

@onready var player = $mcStar_anim

@onready var enemyScene : PackedScene = preload("res://scenes/enemy.tscn")
@onready var lampScene : PackedScene = preload("res://scenes/lanterns.tscn")

@onready var pauseSprite = $pauseMenu/MarginContainer/Pause


var levelUp = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# get scene for restart purposes
	Global.current_scene = "res://scenes/main.tscn"
	
	$music.play()

	inst_lamps(Vector3(-5, 0.5, 0))

	
	# pause mechanisms
	pauseSprite.hide()


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

## instances

func inst_lamps(pos):
	var lamp = lampScene.instantiate()
	lamp.position = pos

	add_child(lamp)


## PAUSE MECH

# stop game time when ESC pressed
# using engine.time_scale because if use get_tree().pause = true then processing
# will stop and can no longer detect input, meaning pause never be unpaused
# so use esc to unpause
func pause():
	Global.isPaused = true
	Engine.time_scale = 0
	get_tree().paused = true
	pauseSprite.show()

# start the time when ESC pressed again
func unpause():
	Global.isPaused = false
	Engine.time_scale = 1
	get_tree().paused = false
	pauseSprite.hide()


## DIALOGUE END MOVE ON LVL


func _on_bibz_level_up():
	$canvasAnim.play("sneakText")

# fade out
func _on_canvas_anim_animation_finished(_anim_name):
	get_tree().change_scene_to_file("res://scenes/UI/tutorial.tscn")
