@tool
extends Node3D

@onready var grid_map : GridMap = $GridMap

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

@export  var giveup : int = 10


@onready var treeScene : PackedScene = preload("res://mapGen/dead_tree_01.tscn")
@onready var bushScene : PackedScene = preload("res://mapGen/dead_bush_02.tscn")


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
		make_forest(giveup)
	print("FOREST POSITIONS: ", forest_positions)
	for i in bush_count:
		make_bushes(giveup)
	print("BUSH POSITIONS: ", bush_positions)


func visualise_border():
	grid_map.clear()
	for i in range (-1, border_size+1):
		grid_map.set_cell_item(Vector3i(i, 0, -1), 3)
		grid_map.set_cell_item(Vector3i(i, 0, border_size), 3)
		grid_map.set_cell_item(Vector3i(border_size, 0, i), 3)
		grid_map.set_cell_item(Vector3i(-1, 0, i), 3)
	
# build forest ground
func make_forest(rec):
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
				make_forest(rec-1)
				return
			
	var forest : PackedVector3Array = []
	# making the forest
	for row in height:
		for col in width:
			var pos : Vector3i = start_pos + Vector3i(col, 0, row)
			grid_map.set_cell_item(pos, 1)
			forest.append(pos)
			
			if randf_range(0, 1) < 0.2: # Adjust the probability as needed
				spawn_tree(pos)
			if randf_range(0, 1) < 0.15: # Adjust the probability as needed
				spawn_bush(pos)
	
	forest_tiles.append(forest)
	
	# calculate cnetre positions to add to posotion array
	var avgX : float = start_pos.x + (float(width)/2)
	var avgZ : float = start_pos.x + (float(height)/2)
	var pos : Vector3 = Vector3(avgX, 0, avgZ)
	forest_positions.append(pos)

func make_bushes(rec):
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
				make_bushes(rec-1)
				return
			
	var bush : PackedVector3Array = []
	# making the bush
	for row in height:
		for col in width:
			var pos : Vector3i = start_pos + Vector3i(col, 0, row)
			grid_map.set_cell_item(pos, 2)
			bush.append(pos)

			if randf_range(0, 1) < 0.5: # Adjust the probability as needed
				spawn_bush(pos)
	
	bush_tiles.append(bush)
	
	# calculate cnetre positions to add to posotion array
	var avgX : float = start_pos.x + (float(width)/2)
	var avgZ : float = start_pos.x + (float(height)/2)
	var pos : Vector3 = Vector3(avgX, 0, avgZ)
	bush_positions.append(pos)


# spawn trees on the forest/tree blocks
func spawn_tree(pos: Vector3):
	# create tree + give height
	var tree = treeScene.instantiate()
	pos.y = 0.9
	
	# rand scale
	var scale_tree = randf_range(0.8, 2)
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
func spawn_bush(pos: Vector3):
	# create bush + give height
	var bush = bushScene.instantiate()
	pos.y = 0.9
	
	# rand scale
	var scale_bush = randf_range(0.8, 2)
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

# spawn broken wall on broken wall blocks
func spawn_broken_wall(pos: Vector3):
	pass

# spawn normal wall on wall blocks
func spawn_normal_wall(pos: Vector3):
	pass

func clear_instantiations():
	print("CLEARING 1")
	for instance in instances:
		instance.queue_free()
	instances.clear()

