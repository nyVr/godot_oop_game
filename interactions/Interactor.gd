extends Area3D

class_name Interactor

var controller: Node3D

# player interacts
func interact(interactable: Interactable):
	interactable.interacted.emit(self)
	
# player in area
func near(interactable: Interactable):
	interactable.nearby.emit(self)
	
# player leaves area 
func far(interactable: Interactable):
	interactable.notNear.emit(self)

# calculate the nearest interactable item to the player
func nearestInteract() -> Interactable:
	var interactableList: Array[Area3D] = get_overlapping_areas()
	var distance: float
	var closestDist: float = INF
	var nearestInt: Interactable = null
	
	for interactable in interactableList:
		distance = interactable.global_position.distance_to(global_position)
		
		if distance < closestDist:
			nearestInt = interactable as Interactable
			closestDist = distance
		
	return nearestInt
