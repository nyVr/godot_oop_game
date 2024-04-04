extends Control


@export_file("*.json") var dia_file

@onready var di_name = $boxBG/name
@onready var di_chat = $boxBG/chat

var dialogue = []
var dialogue_index = 0
var dialogue_on = false

signal dialogue_finished

# when input start dialogue
func _ready():
	$boxBG.visible = false
	
# start dialogue
func start_di(fileName):
	if dialogue_on:
		return
	$boxBG.visible = true
	dialogue_on = true
	dialogue = load_dialogue(fileName)
	dialogue_index = -1
	next_line()
	
# load the file
func load_dialogue(fileName):
	# get file and give read perms
	var file = FileAccess.open(fileName, FileAccess.READ)
	# parse the lines per json and return this to the dialogue array
	var lines = JSON.parse_string(file.get_as_text())
	return lines

# bring the next line
func next_line():
	dialogue_index += 1
	# dialogue ends
	if dialogue_index >= len(dialogue):
		dialogue_on = false
		$boxBG.visible = false
		# emit finished
		emit_signal("dialogue_finished")
		return
	
	# get name and text from file
	di_name.text = dialogue[dialogue_index]['name']
	di_chat.text = dialogue[dialogue_index]['chat']
	
# go through dialogue
func _input(event):
	if !dialogue_on:
		return
	if event.is_action_pressed("Lclick"):
		next_line()
