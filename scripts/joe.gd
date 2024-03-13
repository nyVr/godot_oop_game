extends CharacterBody3D

# onready global (script only)
@onready var healthBar = $CanvasLayer/health
@onready var lanternBar = $CanvasLayer/LanternHp
@onready var timer = $Timer
@onready var health = 100
@onready var lanternHP = 100
@onready var timerWait = 2.5

# wip
signal health_decrease(amountDmg)

# vars
var hitbox
var hitLight
var attackOn = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# on every frame
func _process(_delta):
	timer.wait_time = timerWait # Timer will count down from 5 seconds
	
# on ready local
func _ready():
	timer.start()
	healthBar.init_health(health)
	lanternBar.init_lanternHealth(lanternHP)
	# vars
	hitbox = $hitbox/joeAtkArea
	hitLight = $hitbox/joeAtkArea/joeAttack

# on setting health called
func _set_health(value):
	#super._set_health(value)
	#if health <= 0:
	healthBar.health = health
	
func _set_lanternHealth(value):
	lanternBar.lanternHealth = lanternHP

# on timeout - wip
func _on_timer_timeout():
	lanternHP = lanternHP - 5
	health = health - 5
	_set_health(5)
	_set_lanternHealth(5)
	print(lanternHP)
	print(health)
	
# no joe dies call
func charDeath():
	pass

# movement 
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
	
# on input
func _input(event):
	if lanternHP > 0:
		if event.is_action_pressed("q"):
			print("***ATTACK***")
			hitbox.scale += Vector3(3, 3, 3)
			hitLight.light_energy = 10
			timer.start()
		if event.is_action_released("q"):
			print("***ATTACK RELEASE***")
			hitbox.scale -= Vector3(3, 3, 3)
			hitLight.light_energy = 0
			attackOn = false
		
