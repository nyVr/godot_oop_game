extends ProgressBar

var lanternHealth = 0 : set = _set_lanternHealth


func _set_lanternHealth(newLTHealth):
	var oldHealth = lanternHealth
	lanternHealth = min(max_value, newLTHealth)
	value = lanternHealth
	
	if lanternHealth <= 0:
		queue_free()
		
	
# update lantern health
func init_lanternHealth(_lanternHealth):
	lanternHealth = _lanternHealth
	max_value = lanternHealth
	value = lanternHealth

