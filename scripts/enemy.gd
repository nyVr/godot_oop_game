extends CharacterBody3D

class_name EnemyAI

@onready var navAgent = $NavigationAgent3D
@onready var enemy_bar = $SubViewport/enemyBar
@onready var enemy = $"."
@onready var cooldown = $cd

var SPEED1 = 4.0
var SPEED2 = 2.0
var playerIn = false
var initLoc
var attackDmg = 3
var coolDownSeconds = 3
var canAttack = true
var health = 0 : set = _set_enemy_health


func _process(_delta):
	pass

func _ready():
	# init health
	health = 100
	enemy_bar.value = health
	enemy_bar.max_value = health
	enemy_bar.hide()
	
	# get initial location for later
	initLoc = global_transform.origin
	
	# start enemys cooldown timer
	cooldown.wait_time = coolDownSeconds
	cooldown.start()
	
	# connections
	Global.connect("attacked_enemy", _enemy_attacked)


# calculate movement
func _physics_process(delta):
	if playerIn:
		#print("PLAYER IN -- PHYSICS PROCESS")
		var currLocation = global_transform.origin
		var nextLocation = navAgent.get_next_path_position()
		
		# calculate velocity between curr to next location
		var newVelocity = (nextLocation - currLocation).normalized() * SPEED1
		
		navAgent.set_velocity(newVelocity)
		
		enemy_bar.show()
	
	else:
		move_to_init_pos(delta)
		enemy_bar.hide()


## navigation ai 


# move the enemy back to origin position if the player leaves their detec area
func move_to_init_pos(_delta):
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

# when player in enemy radar start navigation ai
func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		print("***ENEMY DETECTION AREA ENTERED***")
		playerIn = true

# when player leaves enemy radar return enemy to initial position
func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		print("***ENEMY DETECTION AREA EXITED***")
		playerIn = false

# avoid cols using safe velocity
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()


## attack ai


# to get rid of
func _on_enemy_hitbox_body_exited(body):
	if body.is_in_group("player"):
		print("***ENEMY HITBOX AREA EXITED***")

# to get rid of
func _on_enemy_hitbox_body_entered(body):
	if body.is_in_group("player"):
		print("***ENEMY HITBOX AREA ENTERED***")

# in attack range instead of enemy hit box using nav agent
func _on_navigation_agent_3d_target_reached():
	if canAttack:
		print("NAVIGATION TARGET REACHED ATTACKABLE")
		Global.emit_signal("player_attacked", attackDmg)
		canAttack = false


# cooldown for enemy attack 
func _on_cd_timeout():
	canAttack = true

# signal function enemy get attacked
func _enemy_attacked(dmg):
	var newHealth = health - dmg
	_set_enemy_health(newHealth)
	

## setters 

# set enemy health and bar
func _set_enemy_health(newHealth):
	health = clamp(newHealth, 0, enemy_bar.max_value)
	enemy_bar.value = health
	if health <= 0:
		enemy_death()

# kill enemy
func enemy_death():
	queue_free()
