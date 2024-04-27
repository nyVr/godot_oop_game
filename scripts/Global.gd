extends Node

var current_scene = "null"

var canInput = 0

var starsCount = 0

var isPaused = false

var endlessUnlocked = false

var endlessLevel = 1

var endlessStarCount = 0

signal set_health(amount)

signal player_attacked(attackDmg)

signal attacked_enemy(lanternDmg)

signal star_collected()


func _ready():
	SilentWolf.configure({
	"api_key": "bK18wsDPejjaUgD15fjj6dkmczRwm6S3oMUBlUz8",
	"game_id": "starseeker",
	"log_level": 1
	})

	SilentWolf.configure_scores({
	"open_scene_on_close": "res://scenes/MainPage.tscn"
	})
