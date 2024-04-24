extends Node3D

class_name Level2

@onready var player = $mcStar_anim

@onready var enemyScene : PackedScene = preload("res://scenes/enemy.tscn")
@onready var lampScene : PackedScene = preload("res://scenes/lanterns.tscn")
@onready var starScene : PackedScene = preload("res://scenes/dolls.tscn")

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
	
	$music.play()
	
	## instance of enemies
	inst_enemy(Vector3(3, 0.9, 40))
	inst_enemy(Vector3(26.7, 0.9, 37.1))
	inst_enemy(Vector3(42.6, 0.9, 30.1))
	inst_enemy(Vector3(65.3, 0.9, 23))
	inst_enemy(Vector3(46.5, 0.9, -35.6))
	inst_enemy(Vector3(9.7, 0.9, -35.6))
	inst_enemy(Vector3(-13.5, 0.9, -42.2))
	inst_enemy(Vector3(-42.2, 0.9, -26.9))
	inst_enemy(Vector3(-42.2, 0.9, -1.78))
	inst_enemy(Vector3(-38.8, 0.9, 20.3))
	inst_enemy(Vector3(-47.6, 0.9, 39.4))
	
	
	## insance of stars
	inst_stars(Vector3(6.5, 1.2, 40))
	inst_stars(Vector3(66.5, 1.2, 21.5))
	inst_stars(Vector3(65.5, 1.2, -45))
	inst_stars(Vector3(6.1, 1.2, -49.9))
	inst_stars(Vector3(-39.8, 1.2, -44.6))
	inst_stars(Vector3(-58.8, 1.2, -6.6))
	inst_stars(Vector3(-60.3, 1.2, 42.7))
	inst_stars(Vector3(-15.5, 1.2, 46.1))
	inst_stars(Vector3(18.3, 1.2, -17.1))
	inst_stars(Vector3(-18.5, 1.2, -0.1))
	
	
	## instance of lamps
	inst_lamps(Vector3(-29.6, 1, 20))
	inst_lamps(Vector3(42.5, 1, 9))
	inst_lamps(Vector3(-11, 1, -31.4))
	inst_lamps(Vector3(-50.9, 1, -23.4))
	
	
	## pause mechanisms
	pauseSc.hide()


# ev frame
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

# instantiate lamps
func inst_lamps(pos):
	var lamp = lampScene.instantiate()
	lamp.position = pos

	add_child(lamp)

# instatiate stars
func inst_stars(pos):
	var star = starScene.instantiate()
	
	star.rotate_y(deg_to_rad(randf_range(-100, 100)))
	star.rotate_x(deg_to_rad(randf_range(-100, 100)))
	star.rotate_z(deg_to_rad(randf_range(-100, 100)))
	
	star.position = pos

	add_child(star)

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
	var score_text = "Stars collected: " + str(Global.starsCount) + "/10"
	score.text = score_text
	if Global.starsCount == 10:
		get_tree().change_scene_to_file("res://scenes/final.tscn")


func _on_mc_star_anim_mc_died():
	get_tree().change_scene_to_file("res://scenes/UI/youDied.tscn")
