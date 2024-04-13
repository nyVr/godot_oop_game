@tool
extends Node3D

@export var start : bool = false : set = set_start
func set_start(val: bool):
	generate()

@export var enemy_count : int = 2

@onready var enemyScene : PackedScene = preload("res://scenes/enemy.tscn")

@onready var grid_map = $"../GridMap"
@onready var map = $".."



var enemies : Array[Node3D] = []

func generate():
	#  clear
	for enemy in enemies:
		print("FREEING ENEMY")
		enemy.queue_free()
	enemies.clear()
	
	# spawn
	for row in range(0, map.border_size):
		for col in range(-1, map.border_size):
			var pos : Vector3i = Vector3i(col, 0, row)
			if grid_map.get_cell_item(pos) == 0:
				if randf() < 0.001:
					spawn_enemy(pos)


func _ready():
	#  clear
	for enemy in enemies:
		enemy.queue_free()
	enemies.clear()
	
	# spawn
	for row in range(0, map.border_size):
		for col in range(-1, map.border_size):
			var pos : Vector3i = Vector3i(col, 0, row)
			if grid_map.get_cell_item(pos) == 0:
				if randf() < 0.003:
					spawn_enemy(pos)

# spawn enemy
func spawn_enemy(pos : Vector3):
	# create enemy + give height
	print("spawning enemy")
	var enemy = enemyScene.instantiate()
	pos.y = 1.5
	
	# enemy position on block
	enemy.position = pos
	## add to instances for clear
	enemies.append(enemy)
	## create
	add_child(enemy)
