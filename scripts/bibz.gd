extends Node3D

@onready var interaction_area: interactionArea = $InteractionArea
# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_bibs")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_bibs():
	print("BIBZ INTERACTINO DIALOGUE START")
	var dialogue = load("res://dialogue/dialogue01.dialogue")
	if DialogueManager and dialogue:  # Check if DialogueManager is available and dialogue is loaded
		DialogueManager.show_example_dialogue_balloon(dialogue, "intro_meeting")
	print("BIBS INTERACTION DIALOGUE COMPLETE")
