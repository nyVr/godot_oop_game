extends OmniLight3D

# just gds to run light flicker when 1 recharge left

@onready var flickerTimer = $flicker

func _ready():
	flickerTimer.wait_time = randf_range(0, 1)
	flickerTimer.start()
