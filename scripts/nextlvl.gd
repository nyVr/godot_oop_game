extends Area3D

@export_file var nextLevelPath: String = ""


var currentLevel 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _get_configuration_warnings():
	if nextLevelPath == "":
		return "nextLevelPath must be set"
	else:
		return "" 

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Level up area entered - checking requirements")
