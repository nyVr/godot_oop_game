@tool
extends Node3D

# basically creates the gridmap for the world
# also spawns player, enemy, star and lamps
# another script spawns instances so it works with the navigation mesh coll detection
# player spawn first then stars then lamps then enemies
# scenes, forest & bushes spawn after 

@onready var grid_map : GridMap = $GridMap

@onready var player = $mcStar_anim


# to generate the mapp without running the scene
@export var start : bool = false : set = set_start
func set_start(val: bool):
	generate()

# border variable and setter - to make a border so player cant get by
@export var border_size : int = 20 : set = set_border_size
func set_border_size(val : int):
	border_size = val
	if Engine.is_editor_hint():
		visualise_border()


# lamp and enemy count
@export var enemy_count : int = 10 + (2*Global.endlessLevel)
@export var lamp_count : int = 5 + (1*Global.endlessLevel)

var star_count : int = 10


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


# player spawn on 2x2 randomly
var player_tile_size : int = 2


# scenes
@onready var enemyScene : PackedScene = preload("res://scenes/enemy.tscn")
@onready var lampScene : PackedScene = preload("res://scenes/lanterns.tscn")

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

# generate on start 
func generate():
	# clear all arrays and map contents
	forest_tiles.clear()
	forest_positions.clear()
	
	bush_tiles.clear()
	bush_positions.clear()
	
	enemy_tiles.clear()
	enemy_positions.clear()
	
	player_tile.clear()
	player_position.clear()
	
	lamp_tiles.clear()
	lamp_positions.clear()
	
	star_tiles.clear()
	star_positions.clear()
	
	clear_instantiations()
	
	# create border
	print("generating...")
	visualise_border()
	
	# spawn player
	make_player_tile()
	
	# spawn stars
	
	
	# spawn lamps
	
	
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


func spawn_enemy(pos : Vector3):
	# create enemy + give height
	print("spawning enemy")
	var enemy = enemyScene.instantiate()
	pos.y = 1.5
	#
	# enemy position on block
	enemy.position = pos
	## add to instances for clear
	instances.append(enemy)
	## create
	add_child(enemy)


func _ready():
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
	for i in enemy_count:
		make_enemy_tile(giveup)
	
	for i in forest_count:
		make_forest_tiles(giveup)
	print("FOREST POSITIONS: ", forest_positions)
	for i in bush_count:
		make_bush_tiles(giveup)
	print("BUSH POSITIONS: ", bush_positions)
	
	
	$pathfind.bake_navigation_mesh(true)
	print("BAKED MESH")
	
	
	
func _physics_process(delta):
	get_tree().call_group("enemy", "updatePlayerLocation", player.global_transform.origin)
	pass


func visualise_border():
	if grid_map != null:
		grid_map.clear()
	for i in range (-1, border_size+1):
		grid_map.set_cell_item(Vector3i(i, 0, -1), 3)
		grid_map.set_cell_item(Vector3i(i, 0, border_size), 3)
		grid_map.set_cell_item(Vector3i(border_size, 0, i), 3)
		grid_map.set_cell_item(Vector3i(-1, 0, i), 3)


## make tiles

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



## clearer

# clear all instances
func clear_instantiations():
	print("CLEARING 1")
	for instance in instances:
		instance.queue_free()
	instances.clear()


# wait for nav mesh to finish baking
func _on_pathfind_bake_finished():
	spawn_enemy(Vector3(21, 0.9, 9.5))
	make_blank_tiles()
