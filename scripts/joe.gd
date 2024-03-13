extends CharacterBody3D

@onready var healthBar = $CanvasLayer/health
@onready var timer = $Timer
@onready var health = 100



signal health_decrease(amountDmg)

var hitbox
var hitLight

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(_delta):
	timer.wait_time = 5 # Timer will count down from 5 seconds
	
	



func _ready():
	timer.start()
	healthBar.init_health(health)
	
	hitbox = $hitbox/joeAtkArea
	hitLight = $hitbox/joeAtkArea/joeAttack


func _set_health(value):
	#super._set_health(value)
	#if health <= 0:
	pass
	healthBar.health = health


func _on_timer_timeout():
	health = health - 5
	_set_health(5)
	print(health)
	
func charDeath():
	pass


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _input(event):
	if event.is_action_pressed("q"):
		print("***ATTACK***")
		hitbox.scale += Vector3(3, 3, 3)
		hitLight.light_energy = 10
	if event.is_action_released("q"):
		print("***ATTACK RELEASE***")
		hitbox.scale -= Vector3(3, 3, 3)
		hitLight.light_energy = 0
		
