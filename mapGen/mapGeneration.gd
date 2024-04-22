@tool
extends Node3D

@onready var grid_map : GridMap = $GridMap



@onready var player = $joe


@export var start : bool = false : set = set_start
func set_start(val: bool):
	generate()

@export var border_size : int = 20 : set = set_border_size
func set_border_size(val : int):
	border_size = val
	if Engine.is_editor_hint():
		visualise_border()

@export var min_forest_size : int = 2
@export var max_forest_size : int = 5
@export var forest_count : int = 4
@export var forest_spacing : int = 2

@export var min_bush_size : int = 1
@export var max_bush_size : int = 3
@export var bush_count : int = 5
@export var bush_spacing : int = 2



@export  var giveup : int = 5


@onready var enemyScene : PackedScene = preload("res://scenes/enemy.tscn")


var forest_tiles : Array[PackedVector3Array] = []
var forest_positions : PackedVector3Array = []
var bush_tiles : Array[PackedVector3Array] = []
var bush_positions : PackedVector3Array = []
var instances : Array[Node3D] = []


func generate():
	forest_tiles.clear()
	forest_positions.clear()
	bush_tiles.clear()
	bush_positions.clear()
	clear_instantiations()	
	
	print("generating...")
	visualise_border()
	for i in forest_count:
		make_forest_tiles(giveup)
	print("FOREST POSITIONS: ", forest_positions)
	for i in bush_count:
		make_bush_tiles(giveup)
	print("BUSH POSITIONS: ", bush_positions)
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
	
	$pathfind/worldSpawner/groundShape.position = Vector3(colPos, 0.5, colPos)
	$pathfind/worldSpawner/groundShape/groundCol.scale = Vector3(border_size, 1, border_size)
	
	
	print("generating...")
	visualise_border()
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
	


func visualise_border():
	grid_map.clear()
	for i in range (-1, border_size+1):
		grid_map.set_cell_item(Vector3i(i, 0, -1), 3)
		grid_map.set_cell_item(Vector3i(i, 0, border_size), 3)
		grid_map.set_cell_item(Vector3i(border_size, 0, i), 3)
		grid_map.set_cell_item(Vector3i(-1, 0, i), 3)
	
# build forest ground
func make_forest_tiles(rec):
	if !rec > 0:
		return
	
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


func make_blank_tiles():
	for row in range(-1, border_size):
		for col in range(-1, border_size):
			var pos : Vector3i = Vector3i(col, 0, row)
			if grid_map.get_cell_item(pos) == -1:
				grid_map.set_cell_item(pos, 0)
				
				#if randf() < 0.005:
					#print("ENEMY SPAWNED")
					#spawn_enemy(pos)



func clear_instantiations():
	print("CLEARING 1")
	for instance in instances:
		instance.queue_free()
	instances.clear()



func _on_pathfind_bake_finished():
	spawn_enemy(Vector3(21, 0.9, 9.5))
	make_blank_tiles()
