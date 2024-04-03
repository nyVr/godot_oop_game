extends OmniLight3D

@onready var flickerTimer = $flicker

func _ready():
	flickerTimer.wait_time = randf_range(0, 1)
	flickerTimer.start()
