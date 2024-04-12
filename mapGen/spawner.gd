@tool
extends Node3D


@onready var grid_map = $"../GridMap"


@export var start : bool = false : set = set_start
func set_start(val: bool):
	if Engine.is_editor_hint():
		generate()



@onready var treeScene : PackedScene = preload("res://mapGen/dead_tree_01.tscn")
@onready var bushScene : PackedScene = preload("res://mapGen/dead_bush_02.tscn")
@onready var collisionScene : PackedScene = preload("res://mapGen/cells.tscn")


var instances : Array[Node3D] = []


func generate():
	clear_instantiations()
	for c in get_children():
		remove_child(c)
		c.queue_free()
		
	for cell in grid_map.get_used_cells():
		var cell_type : int = grid_map.get_cell_item(cell)
	
	
func _ready():
	pass

func make_forest(pos):
	var collision = collisionScene.instantiate()
	collision.position = pos
	add_child(collision)
	
	if randf_range(0, 1) < 0.2: # Adjust the probability as needed
		spawn_tree(pos)
	if randf_range(0, 1) < 0.15: # Adjust the probability as needed
		spawn_bush(pos)


func make_bushes(pos):

	var collision = collisionScene.instantiate()
	collision.position = pos
	add_child(collision)

	if randf_range(0, 1) < 0.5: # Adjust the probability as needed
		spawn_bush(pos)
	

## spawners

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
