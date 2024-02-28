extends Area3D

class_name interactionArea

@export var action_name: String = "init"

# can be overriden content of interaction
var interact: Callable = func():
	pass

func _on_body_entered(body):
	InteractionManager.registerArea(self)


func _on_body_exited(body):
	InteractionManager.unregisterArea(self)
