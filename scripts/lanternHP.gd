extends ProgressBar

var lanternHealth = 0 : set = _set_lanternHealth

# update lantern health
func _set_lanternHealth(newLTHealth):
	var _oldHealth = lanternHealth
	lanternHealth = min(max_value, newLTHealth)
	value = lanternHealth
	
	if lanternHealth <= 0:
		queue_free()
		
	
# init lantern health
func init_lanternHealth(_lanternHealth):
	lanternHealth = _lanternHealth
	max_value = lanternHealth
	value = lanternHealth

