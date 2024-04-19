extends Node3D

class_name Level2

@onready var player = $joe

@onready var enemyScene : PackedScene = preload("res://scenes/enemy.tscn")
@onready var lampScene : PackedScene = preload("res://scenes/lanterns.tscn")

@onready var score = $scoreCanv/score
@onready var pauseSc = $pauseCanv/Pause


var levelUp = false

#
func _physics_process(_delta):
	get_tree().call_group("enemy", "updatePlayerLocation", player.global_transform.origin)

# Called when the node enters the scene tree for the first time.
func _ready():
	# get scene for restart purposes
	Global.current_scene = "res://scenes/level2.tscn"
	
	# reset stars
	Global.starsCount = 0
	
	Global.connect("star_collected", _star_collected)
	
	
	## instance of enemies
	inst_enemy(Vector3(3, 0.9, 40))
	
	## instance of lamps
	
	# pause mechanisms
	pauseSc.hide()


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


## instances


# instantiate enemies
func inst_enemy(pos):
	var enemy = enemyScene.instantiate()
	enemy.position = pos
	add_child(enemy)

func inst_lamps(pos):
	var lamp = lampScene.instantiate()
	lamp.position = pos

	add_child(lamp)

## pause mechanisms


# stop game time when ESC pressed
# using engine.time_scale because if use get_tree().pause = true then processing
# will stop and can no longer detect input, meaning pause never be unpaused
func pause():
	Global.isPaused = true
	Engine.time_scale = 0
	get_tree().paused = true
	pauseSc.show()

# start the time when ESC pressed again
func unpause():
	Global.isPaused = false
	Engine.time_scale = 1
	get_tree().paused = false
	pauseSc.hide()


## sigfnals

# update label when star collected
func _star_collected():
	print("EMITTED")
	var score_text = "Stars collected: " + str(Global.starsCount)
	score.text = score_text
