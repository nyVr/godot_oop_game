extends ProgressBar

@onready var timer = $Timer
@onready var damageBar = $damage

var health = 0 : set = _set_health


func _ready():
	Global.connect("set_health", _set_health)

# update health and damage bar delay
func _set_health(newHealth):
	var oldHealth = health
	health = clamp(newHealth, 0, max_value)
	value = health
	
	if health <= 0:
		queue_free()
		
	if health < oldHealth:
		timer.start()
	else:
		damageBar.value = health
	
# init health 
func init_health(_health):
	health = _health
	max_value = health
	value = health
	damageBar.max_value = health
	damageBar.value = health
	
# damage bar delay for health bar
func _on_timer_timeout():
	damageBar.value = health
