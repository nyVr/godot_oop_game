extends Node3D

#@onready var interaction_area: interactionArea = $InteractionArea

var inputReady = 0

signal unpauseWorld_dialogue
signal pauseWorld_dialogue

# array of dialogue?

# onready local
func _ready():
	pass

# every frame
func _process(_delta):
	if inputReady && Input.is_action_just_pressed("interact"):
		print("*****BIBZ INTERACTINO DIALOGUE START*****")
		emit_signal("pauseWorld_dialogue")
		$Chatbox.start_di()
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


func _on_chatbox_dialogue_finished():
	emit_signal("unpauseWorld_dialogue")
