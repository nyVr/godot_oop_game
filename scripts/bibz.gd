extends Node3D

#@onready var interaction_area: interactionArea = $InteractionArea

var inputReady = 0

# onready local
func _ready():
	pass

# every frame
func _process(_delta):
	if inputReady && Input.is_action_just_pressed("interact"):
		print("*****BIBZ INTERACTINO DIALOGUE START*****")
		var dialogue = load("res://dialogue/dialogue01.dialogue")
		if DialogueManager and dialogue:  # Check if DialogueManager is available and dialogue is loaded
			DialogueManager.show_example_dialogue_balloon(dialogue, "intro_meeting")
		print("*****BIBS INTERACTION DIALOGUE COMPLETE*****")
	

# joe enters interaction area
func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		print("***INTERACTION AREA ENTERED***")
		inputReady = 1

# joe leaves interaction area
func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		print("***INTERCACTION AREA LEFT***")
