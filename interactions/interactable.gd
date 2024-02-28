extends Area3D

class_name Interactable

signal nearby(interactor: Interactor)
signal notNear(interactor: Interactor)
signal interacted(interactor: Interactor)


func _on_interacted(interactor):
	var dialogue = load("res://dialogue/bibzSpeech.dialogue")
	if DialogueManager and dialogue:  # Check if DialogueManager is available and dialogue is loaded
		DialogueManager.show_example_dialogue_balloon(dialogue, "bibz_first_meet")



func _on_nearby(interactor):
	pass # Replace with function body.


func _on_not_near(interactor):
	pass # Replace with function body.
