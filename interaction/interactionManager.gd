extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

const baseText = "PRESS [E]"

var activeAreas = []
var canInteract = true

func registerArea(area: interactionArea):
	activeAreas.push_back(area)
	
func unregisterArea(area: interactionArea):
	var index = activeAreas.find(area)
	# if index exists remove it from the array
	if index != -1:
		activeAreas.remove_at(index)
		
func _process(delta):
	# if there are interactive areas find the closest
	if activeAreas.size() > 0 && canInteract:
		activeAreas.sort_custom(sortByDist)
		# centre the label text
		label.text = baseText + activeAreas[0].action_name
		label.show()


	else:
		label.hide()
		
func _input(event):
	if event.is_action_pressed("interact") && canInteract:
		if activeAreas.size() > 0:
			canInteract = false
			await activeAreas[0].interact.call()
			canInteract = true
		
# sort by the distance of each interactive area, with the first one bing the closest one
func sortByDist(area1, area2):
	var area1TOPlayer = player.global_position.distance_to(area1.global_position)
	var area2TOPlayer = player.global_position.distance_to(area2.global_position)
	return area1TOPlayer > area2TOPlayer
	
