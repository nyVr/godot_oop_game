@tool
extends Node3D

# basically creates the gridmap for the world
# also spawns player, enemy, star and lamps
# another script spawns instances so it works with the navigation mesh coll detection
# player spawn first then stars then lamps then enemies
# scenes, forest & bushes spawn after 

# to generate the mapp without running the scene
@export var start : bool = false : set = set_start
func set_start(_val: bool):
	generate()

# border variable and setter - to make a border so player cant get by
@export var border_size : int = 80 : set = set_border_size
func set_border_size(val : int):
	border_size = val
	if Engine.is_editor_hint():
		visualise_border_gen()

# to avoid recursion error
@export  var giveup : int = 5

# forest
@export var min_forest_size : int = 2
@export var max_forest_size : int = 5
@export var forest_count : int = 4
@export var forest_spacing : int = 2

# bushes
@export var min_bush_size : int = 1
@export var max_bush_size : int = 3
@export var bush_count : int = 5
@export var bush_spacing : int = 2

## READIES

@onready var grid_map : GridMap = $GridMap
@onready var player = $mcStar_anim
@onready var pauseSc = $pauseCanv/Pause
@onready var score = $scoreCanv/score
@onready var total_score = $scoreCanv/totalScore


# lamp and enemy count
@onready var enemy_count
@onready var lamp_count
@onready var star_count : int = 10

@onready var level = Global.endlessLevel

@onready var starInCol = 0

# scenes
@onready var enemyScene : PackedScene = preload("res://scenes/enemy.tscn")
@onready var lampScene : PackedScene = preload("res://scenes/lanterns.tscn")
@onready var starScene : PackedScene = preload("res://scenes/dolls.tscn")
@onready var colScene : PackedScene = preload("res://mapGen/sceneGeneration/colonly.tscn")
@onready var treeScene : PackedScene = preload("res://mapGen/sceneGeneration/dead_tree_01.tscn")
@onready var bushScene : PackedScene = preload("res://mapGen/sceneGeneration/dead_bush_02.tscn")


# tile arrays
var forest_tiles : Array[PackedVector3Array] = []
var forest_positions : PackedVector3Array = []

var bush_tiles : Array[PackedVector3Array] = []
var bush_positions : PackedVector3Array = []

var player_tile 
var player_position

var star_tiles : Array[PackedVector3Array] = []
var star_positions : PackedVector3Array = []

var lamp_tiles : Array[PackedVector3Array] = []
var lamp_positions : PackedVector3Array = []

var enemy_tiles : Array[PackedVector3Array] = []
var enemy_positions : PackedVector3Array = []

var instances : Array[Node3D] = []

var spawncount = 0 

## EDITOR RUN

# generate on start 
func generate():
	var level = 0
	star_count = 10
	lamp_count = 5 + (1*level)
	
	# clear all arrays and map contents
	forest_tiles.clear()
	forest_positions.clear()
	
	bush_tiles.clear()
	bush_positions.clear()
	
	enemy_tiles.clear()
	enemy_positions.clear()
	
	#player_tile.clear()
	#player_position.clear()
	
	lamp_tiles.clear()
	lamp_positions.clear()
	
	star_tiles.clear()
	star_positions.clear()
	
	clear_instantiations()
	
	# create border
	print("generating...")
	visualise_border_gen()
	
	## CALL MAKE TILES
	
	# spawn player
	make_player_tile()
	
	print("STAR COUNT: ", star_count)
	# spawn stars
	for i in star_count:
		make_star_tile(giveup)
	print("STAR POSITIONS: ", star_positions)
	
	# spawn lamps
	for i in lamp_count:
		make_lamp_tile(giveup)
	print("LAMP POSITIONS: ", lamp_positions)
	
	# spawn enemies
	for i in enemy_count:
		make_enemy_tile(giveup)
	print("ENEMY POSITIONS: ", enemy_positions)
	
	# make forest tiles - world spawner spawns in scenes (for nav mesh)
	for i in forest_count:
		make_forest_tiles(giveup)
	print("FOREST POSITIONS: ", forest_positions)
	
	# make bush tiles - world spawner spawns in scenes (for nav mesh)
	for i in bush_count:
		make_bush_tiles(giveup)
	print("BUSH POSITIONS: ", bush_positions)
	
	# fill in rest of gridmap
	make_blank_tiles()


# visualise border for generate function ot avoid instant errors
func visualise_border_gen():
	if grid_map != null:
		grid_map.clear()
	for i in range (-1, border_size+1):
		grid_map.set_cell_item(Vector3i(i, 0, -1), 3)
		grid_map.set_cell_item(Vector3i(i, 0, border_size), 3)
		grid_map.set_cell_item(Vector3i(border_size, 0, i), 3)
		grid_map.set_cell_item(Vector3i(-1, 0, i), 3)


## RUNTIME

# ready
func _ready():
	pauseSc.hide()
	
	Global.connect("star_collected", _star_collected)
	
	if level == 1:
		Global.endlessStarCount = 0
	var total_score_text = "Total: " + str(Global.endlessStarCount)
	total_score.text = total_score_text
	
	lamp_count = 5 + (1*level)
	enemy_count = 15 + (1*level)
	star_count = 10
	
	var lvlText = "Level: " + str(level)
	$scoreCanv/level.text = lvlText
	
	print("LAMP COUNT", lamp_count, " ENEMY COUNT", enemy_count)
	# clear collision ground and reset position
	$pathfind/worldSpawner.position = Vector3(0, 0, 0)
	$pathfind/worldSpawner/groundShape/groundCol.position = Vector3(0, 0, 0)
	$pathfind/worldSpawner/groundShape/groundMats.position = Vector3(0, 0, 0)
	$pathfind/worldSpawner/groundShape/groundCol.scale = Vector3(1, 1, 1)
	
	forest_tiles.clear()
	forest_positions.clear()
	bush_tiles.clear()
	bush_positions.clear()
	clear_instantiations()
	
	var colPos : int = int(border_size / 2) 
	
	# recreate collision grounf and position
	$pathfind/worldSpawner/groundShape.position = Vector3(colPos, 0.5, colPos)
	$pathfind/worldSpawner/groundShape/groundCol.scale = Vector3(border_size, 1, border_size)
	$pathfind/worldSpawner/groundShape/groundMats.scale = Vector3(border_size, 1, border_size)
	
	print("generating...")
	visualise_border()

	# spawn player
	make_player_tile()
	
	print("STAR COUNT: ", star_count)
	# spawn stars
	for i in star_count:
		make_star_tile(giveup)
	print("STAR POSITIONS: ", star_positions)
	
	# spawn lamps
	for i in lamp_count:
		make_lamp_tile(giveup)
	print("LAMP POSITIONS: ", lamp_positions)
	
	# spawn enemies
	for i in enemy_count:
		make_enemy_tile(giveup)
	print("ENEMY POSITIONS: ", enemy_positions)
	
	# make forest tiles - world spawner spawns in scenes (for nav mesh)
	for i in forest_count:
		make_forest_tiles(giveup)
	print("FOREST POSITIONS: ", forest_positions)
	
	# make bush tiles - world spawner spawns in scenes (for nav mesh)
	for i in bush_count:
		make_bush_tiles(giveup)
	print("BUSH POSITIONS: ", bush_positions)
	
	# fill in rest of gridmap
	make_blank_tiles()
	
	# spawn everything
	for pos in enemy_positions:
		spawn_enemy(pos)
	for pos in lamp_positions:
		spawn_lamps(pos)
	for pos in star_positions:
		spawn_stars(pos)
	
	# spawn trees
	for row in range(-1, border_size):
		for col in range(-1, border_size):
			var pos : Vector3i = Vector3i(col, 0, row)
			if grid_map.get_cell_item(pos) == 1:
				if randf_range(0, 1) < 0.1:
					spawn_tree(pos)
				if randf_range(0, 1) < 0.15:
					spawn_bush(pos)
			elif grid_map.get_cell_item(pos) == 2:
				if randf_range(0, 1) < 0.5:
					spawn_bush(pos)
	
	print("SPAWNED EVERYTHING COMPLETE")
	$pathfind.bake_navigation_mesh(true)
	print("BAKED MESH")


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Global.isPaused:
			print("***UNPAUSE***")
			unpause()
		else:
			print("***PAUSE***")
			pause()
	else:
		pass



# update player location for enemy
func _physics_process(_delta):
	get_tree().call_group("enemy", "updatePlayerLocation", player.global_transform.origin)
	pass

# visualise border
func visualise_border():
	if grid_map != null:
		grid_map.clear()
	for i in range (-1, border_size+1):
		grid_map.set_cell_item(Vector3i(i, 0, -1), 3)
		spawn_collision(Vector3i(i, 0, -1))
		grid_map.set_cell_item(Vector3i(i, 0, border_size), 3)
		spawn_collision(Vector3i(i, 0, border_size))
		grid_map.set_cell_item(Vector3i(border_size, 0, i), 3)
		spawn_collision(Vector3i(border_size, 0, i))
		grid_map.set_cell_item(Vector3i(-1, 0, i), 3)
		spawn_collision(Vector3i(-1, 0, i))


## SPAWNERS

# spawn enemy scene
func spawn_enemy(pos):
	# create enemy + give height
	var enemy = enemyScene.instantiate()
	pos.y = 1.5
	
	
	# enemy position on block
	enemy.position = pos
	## add to instances for clear
	instances.append(enemy)
	spawncount += 1
	print("SPAWN COUNT: ", spawncount)
	## create
	add_child(enemy)

# spawn lamp scene
func spawn_lamps(pos):
	var lamp = lampScene.instantiate()
	pos.y = 1
	lamp.position = pos
	instances.append(lamp)
	add_child(lamp)

# spawn star scene
func spawn_stars(pos):
	var star = starScene.instantiate()
	pos.y = 2
	star.position = pos
	instances.append(star)
	add_child(star)

# spawn collision walls
func spawn_collision(pos):
	var col = colScene.instantiate()
	pos.y = 2
	col.position = pos
	instances.append(col)
	add_child(col)

# spawn trees on the forest/tree blocks
func spawn_tree(pos):
	# create tree + give height
	var tree = treeScene.instantiate()
	pos.y = 0.9
	
	# rand scale
	var scale_tree = randf_range(0.8, 3)
	tree.scale = Vector3(scale_tree, scale_tree, scale_tree)
	
	# tree position on block
	tree.position = pos
	# rand rotate
	tree.rotate_y(randf_range(-20, 20))
	tree.rotate_x(randf_range(-0.5, 0.5))
	
	# add to instances for clear
	instances.append(tree)
	# create
	add_child(tree)

# spawn bushes on the forest/bush blocks
func spawn_bush(pos):
	# create bush + give height
	var bush = bushScene.instantiate()
	pos.y = 1.5
	
	# rand scale
	var scale_bush = randf_range(0.8, 3)
	bush.scale = Vector3(scale_bush, scale_bush, scale_bush)
	
	# bush position on block
	bush.position = pos
	# rand rotate
	bush.rotate_y(randf_range(-20, 20))
	bush.rotate_x(randf_range(-0.5, 0.5))
	
	# add to instances for clear
	instances.append(bush)
	# create
	add_child(bush)

## TILE MAKERS

# make player 2x2 tile so they dont spawn randommly stuck
func make_player_tile():
	var size = 2
	
	var start_pos : Vector3i 
	start_pos.x = randi() % (border_size - size + 1)
	start_pos.z = randi() % (border_size - size + 1)
	
	# since this first thing we make, eveything else is empty so we dont need 
	# to recursivley check if tiles are used
	# so make all 4 tiles player tiles
	grid_map.set_cell_item(start_pos, 7)
	grid_map.set_cell_item(start_pos + Vector3i(1, 0, 0), 7)
	grid_map.set_cell_item(start_pos + Vector3i(0, 0, 1), 7)
	grid_map.set_cell_item(start_pos + Vector3i(1, 0, 1), 7)
	
	$mcStar_anim.position = Vector3(start_pos.x, 1, start_pos.z)


# make star tiles
func make_star_tile(rec):
	if !rec > 0:
		return
	
	var start_pos : Vector3i
	start_pos.x = randi() % (border_size - 1)
	start_pos.z = randi() % (border_size - 1)
	
	var pos : Vector3i = start_pos
	
	# check is position is empty
	if grid_map.get_cell_item(pos) != -1:
		make_star_tile(rec-1)
		return
	# position is empty
	grid_map.set_cell_item(pos, 5)
	
	# append position
	star_positions.append(pos)
	
	# append to tiles
	var starT : PackedVector3Array = []
	starT.append(pos)
	star_tiles.append(starT)


# make lamp tiles
func make_lamp_tile(rec):
	if !rec > 0:
		return
	
	var start_pos : Vector3i
	start_pos.x = randi() % (border_size - 1)
	start_pos.z = randi() % (border_size - 1)
	
	var pos : Vector3i = start_pos
	
	# check is position is empty
	if grid_map.get_cell_item(pos) != -1:
		make_lamp_tile(rec-1)
		return
	# position is empty
	grid_map.set_cell_item(pos, 6)
	
	# append position
	lamp_positions.append(pos)
	
	# append to tiles
	var lampT : PackedVector3Array = []
	lampT.append(pos)
	lamp_tiles.append(lampT)


# make enemy tiles
func make_enemy_tile(rec):
	if !rec > 0:
		return
	
	var start_pos : Vector3i
	start_pos.x = randi() % (border_size - 1)
	start_pos.z = randi() % (border_size - 1)
	
	var pos : Vector3i = start_pos
	
	# check is position is empty
	if grid_map.get_cell_item(pos) != -1:
		make_enemy_tile(rec-1)
		return
	# position is empty
	grid_map.set_cell_item(pos, 4)
	
	# append position
	enemy_positions.append(pos)
	
	# append to tiles
	var enemyT : PackedVector3Array = []
	enemyT.append(pos)
	enemy_tiles.append(enemyT)


# build forest ground
func make_forest_tiles(rec):
	if !rec > 0:
		return
	
	# rand width and height between max and min size
	var width = (randi() % (max_forest_size - min_forest_size)) + min_forest_size
	var height = (randi() % (max_forest_size - min_forest_size)) + min_forest_size

	var start_pos : Vector3i
	start_pos.x = randi() % (border_size - width + 1)
	start_pos.z = randi() % (border_size - height + 1)
	
	# avoiding forect collusoins
	for row in range(-forest_spacing, height+forest_spacing):
		for col in range(-forest_spacing, width+forest_spacing):
			var pos : Vector3i = start_pos + Vector3i(col, 0, row)
			if grid_map.get_cell_item(pos) != -1:
				make_forest_tiles(rec-1)
				return
			
	var forest : PackedVector3Array = []
	# making the forest
	for row in height:
		for col in width:
			var pos : Vector3i = start_pos + Vector3i(col, 0, row)
			grid_map.set_cell_item(pos, 1)
			forest.append(pos)
	
	forest_tiles.append(forest)
	
	# calculate cnetre positions to add to posotion array
	var avgX : float = start_pos.x + (float(width)/2)
	var avgZ : float = start_pos.x + (float(height)/2)
	var pos : Vector3 = Vector3(avgX, 0, avgZ)
	forest_positions.append(pos)


# make bush tiles
func make_bush_tiles(rec):
	if !rec > 0:
		return
	
	var width = (randi() % (max_bush_size - min_bush_size)) + min_bush_size
	var height = (randi() % (max_bush_size - min_bush_size)) + min_bush_size

	var start_pos : Vector3i
	start_pos.x = randi() % (border_size - width + 1)
	start_pos.z = randi() % (border_size - height + 1)
	
	# avoiding forect collusoins
	for row in range(-bush_spacing, height+bush_spacing):
		for col in range(-bush_spacing, width+bush_spacing):
			var pos : Vector3i = start_pos + Vector3i(col, 0, row)
			if grid_map.get_cell_item(pos) != -1:
				make_bush_tiles(rec-1)
				return
			
	var bush : PackedVector3Array = []
	# making the bush
	for row in height:
		for col in width:
			var pos : Vector3i = start_pos + Vector3i(col, 0, row)
			grid_map.set_cell_item(pos, 2)
			bush.append(pos)
	
	bush_tiles.append(bush)
	
	# calculate cnetre positions to add to posotion array
	var avgX : float = start_pos.x + (float(width)/2)
	var avgZ : float = start_pos.x + (float(height)/2)
	var pos : Vector3 = Vector3(avgX, 0, avgZ)
	bush_positions.append(pos)


# make normal wall tiles
func make_plain_wall_tiles():
	pass


# make broken wall tiles
func make_brok_wall_tiles():
	pass


# fill in blank tiles
func make_blank_tiles():
	for row in range(-1, border_size):
		for col in range(-1, border_size):
			var pos : Vector3i = Vector3i(col, 0, row)
			if grid_map.get_cell_item(pos) == -1:
				grid_map.set_cell_item(pos, 0)


## PAUSE

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


## CLEARERS


# clear all instances
func clear_instantiations():
	print("CLEARING 1")
	for instance in instances:
		instance.queue_free()
	instances.clear()


## WIN CONDITIONS

func _star_collected():
	starInCol += 1
	var score_text = "Stars collected: " + str(Global.starsCount) + "/10"
	score.text = score_text
	
	Global.endlessStarCount += 1
	var total_score_text = "Total stars: " + str(Global.endlessStarCount)
	total_score.text = total_score_text
	if starInCol == 10:
		Global.endlessLevel += 1
		get_tree().change_scene_to_file("res://mapGen/map.tscn")


## LOSE CONDITIONS

func _on_mc_star_anim_mc_died():
	Global.endlessLevel = 1
	get_tree().change_scene_to_file("res://scenes/UI/youDiedEndlessVer.tscn")
