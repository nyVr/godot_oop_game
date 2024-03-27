extends CharacterBody3D

@onready var navAgent = $NavigationAgent3D

var SPEED = 3.0
var playerIn = false

# calculate movement
func _physics_process(delta):
	if playerIn:
		var currLocation = global_transform.origin
		var nextLocation = navAgent.get_next_path_position()
		
		# calculate velocity between curr to next location
		var newVelocity = (nextLocation - currLocation).normalized() * SPEED
		
		navAgent.set_velocity(newVelocity)

# set taregt location (player location)
func updatePlayerLocation(playerLocation):
	navAgent.target_position = playerLocation

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		print("***ENEMY DETECTION AREA ENTERED***")
		playerIn = true

func _on_enemy_hitbox_body_exited(body):
	if body.is_in_group("player"):
		print("***ENEMY DETECTION AREA EXITED***")
		playerIn = true

func _on_enemy_hitbox_body_entered(body):
	if body.is_in_group("player"):
		print("***ENEMY HITBOX AREA ENTERED***")
		


func _on_navigation_agent_3d_target_reached():
	print("****TARGET REACHED****")


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
