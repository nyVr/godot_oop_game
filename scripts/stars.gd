extends Area3D

# star that rotates, and has gpu particles
# plays ambientish sound so it can be found
# plays collection sound when collected then queue free

#  rotation
const ROT_SPEED = 2

# onready
func _ready():
	Global.starsCount = 0
	$bg.play()

# rotate every frame by 2 deg rad
func _process(_delta):
	rotate_y(deg_to_rad(ROT_SPEED))
	
# when star collected, play sound and hide it
func _on_body_entered(body):
	if body.is_in_group("player"):
		$bg.stop()
		$collect.play()
		$".".hide()

# when sound finishes
# add it to the total and free star
func _on_collect_finished():
	queue_free() 
	Global.starsCount += 1
	Global.emit_signal("star_collected")
	print("Stars collected: ", Global.starsCount) 
