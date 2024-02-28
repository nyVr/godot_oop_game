extends Interactor

@export var player: CharacterBody3D

var currentClosestInt: Interactable

func _ready() -> void:
	controller = player
	
# get the closest interactable objetc
func _physics_process(_delta):
	var newClosestInt: Interactable = nearestInteract()
	if newClosestInt != currentClosestInt:
		if is_instance_valid(currentClosestInt):
			far(currentClosestInt)
		if newClosestInt:
			near(currentClosestInt)
			
		currentClosestInt = newClosestInt 
	
# player is near interactable area and presses E	
func _input(event: InputEvent):
	if event.is_action_pressed("interact"):
		if currentClosestInt:
			interact(currentClosestInt)

# character leaves interactable area
func _on_area_exited(area: Interactable):
	if currentClosestInt == area:
		far(area)
		
		

