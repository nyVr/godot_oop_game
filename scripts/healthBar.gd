extends ProgressBar

@onready var timer = $Timer
@onready var damageBar = $damage

var health = 0 : set = _set_health


func _set_health(newHealth):
	var oldHealth = health
	health = min(max_value, newHealth)
	value = health
	
	if health <= 0:
		queue_free()
		
	if health < oldHealth:
		timer.start()
	else:
		damageBar.value = health
	


func init_health(_health):
	health = _health
	max_value = health
	value = health
	damageBar.max_value = health
	damageBar.value = health
	

func _on_timer_timeout():
	damageBar.value = health
