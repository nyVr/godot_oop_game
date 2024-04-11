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
@export  var giveup : int = 10


@onready var treeScene : PackedScene = preload("res://mapGen/dead_tree_01.tscn")
@onready var bushScene : PackedScene = preload("res://mapGen/dead_bush_02.tscn")


var forest_tiles : Array[PackedVector3Array] = []
var forest_positions : PackedVector3Array = []
var instances : Array[Node3D] = []



func generate():
	forest_tiles.clear()
	forest_positions.clear()
	clear_instantiations()
	print("generating...")
	visualise_border()
	for i in forest_count:
		make_forest(giveup)
	print(forest_positions)

func visualise_border():
	grid_map.clear()
	for i in range (-1, border_size+1):
		grid_map.set_cell_item(Vector3i(i, 0, -1), 4)
		grid_map.set_cell_item(Vector3i(i, 0, border_size), 4)
		grid_map.set_cell_item(Vector3i(border_size, 0, i), 4)
		grid_map.set_cell_item(Vector3i(-1, 0, i), 4)
	

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
			if grid_map.get_cell_item(pos) == 0:
				make_forest(rec-1)
				return
			
	var forest : PackedVector3Array = []
	# making the forest
	for row in height:
		for col in width:
			var pos : Vector3i = start_pos + Vector3i(col, 0, row)
			grid_map.set_cell_item(pos, 0)
			forest.append(pos)
			
			if randf() < 0.2: # Adjust the probability as needed
				spawn_tree(pos)
	
	forest_tiles.append(forest)
	
	# calculate cnetre positions to add to posotion array
	var avgX : float = start_pos.x + (float(width)/2)
	var avgZ : float = start_pos.x + (float(height)/2)
	var pos : Vector3 = Vector3(avgX, 0, avgZ)
	forest_positions.append(pos)

func spawn_tree(pos: Vector3):
	# create tree
	var tree = treeScene.instantiate()
	pos.y = 1
	
	# rand scale
	var scale_tree = randf_range(0.8, 2)
	tree.scale = Vector3(scale_tree, scale_tree, scale_tree)
	
	
	tree.position = pos

	# rand rotate
	tree.rotate_y(randf_range(-20, 20))
	tree.rotate_x(randf_range(-0.5, 0.5))
	
	# add to instances for clear
	instances.append(tree)
	# create
	add_child(tree)

func spawn_bush(pos: Vector3):
	pass

func clear_instantiations():
	print("CLEARING 1")
	for instance in instances:
		instance.queue_free()
	instances.clear()

