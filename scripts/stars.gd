extends Area3D

const ROT_SPEED = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.starsCount = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotate_y(deg_to_rad(ROT_SPEED))
	

func _on_body_entered(body):
	if body.is_in_group("player"):
		queue_free() 
		
		Global.starsCount += 1
		
		print("Stars collected: ", Global.starsCount) 


