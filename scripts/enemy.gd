extends CharacterBody3D

@onready var navAgent = $NavigationAgent3D
@onready var health = 100
@onready var attackCD = 2
@onready var enemy_bar = $SubViewport/enemyBar
@onready var enemy = $"."


var SPEED1 = 4.0
var SPEED2 = 2.0
var playerIn = false
var initLoc


func _process(delta):
	pass

func _ready():
	enemy_bar.value = health
	enemy_bar.hide()
	initLoc = global_transform.origin


# calculate movement
func _physics_process(delta):
	if playerIn:
		var currLocation = global_transform.origin
		var nextLocation = navAgent.get_next_path_position()
		
		# calculate velocity between curr to next location
		var newVelocity = (nextLocation - currLocation).normalized() * SPEED1
		
		navAgent.set_velocity(newVelocity)
		
		enemy_bar.show()
		
		if enemy_bar.value > 0:
			enemy_bar.value -= delta * 2
	
	else:
		move_to_init_pos(delta)
		enemy_bar.hide()
		

# move the enemy back to origin position if the player leaves their detec area
func move_to_init_pos(delta):
	var direction = (initLoc - global_transform.origin).normalized()
	velocity = direction * SPEED2
	move_and_slide()
	
	# if close enough to init pos stop moving to it doesnt start bugging out
	if global_transform.origin.distance_to(initLoc) < 0.1:
		global_transform.origin = initLoc
		velocity = Vector3.ZERO
	


# set taregt location (player location)
func updatePlayerLocation(playerLocation):
	navAgent.target_position = playerLocation



func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		print("***ENEMY DETECTION AREA ENTERED***")
		playerIn = true



func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		print("***ENEMY DETECTION AREA EXITED***")
		playerIn = false


func _on_enemy_hitbox_body_exited(body):
	if body.is_in_group("player"):
		print("***ENEMY HITBOX AREA EXITED***")



func _on_enemy_hitbox_body_entered(body):
	if body.is_in_group("player"):
		print("***ENEMY HITBOX AREA ENTERED***")
		




func _on_navigation_agent_3d_target_reached():
	print("****TARGET REACHED****")




func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()


