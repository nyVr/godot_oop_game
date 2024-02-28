extends Area3D

class_name interactionArea

@export var action_name: String = "init"

# can be overriden content of interaction
var interact: Callable = func():
	pass

func _on_body_entered(body):
	print("body_entered()")
	InteractionManager.registerArea(self)


func _on_body_exited(body):
	print("body_exited()")
	InteractionManager.unregisterArea(self)
