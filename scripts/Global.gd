extends Node

var current_scene = "null"

var canInput = 0

var starsCount = 0

var isPaused = false

var endlessUnlocked = false

signal set_health(amount)

signal player_attacked(attackDmg)

signal attacked_enemy(lanternDmg)

signal star_collected()
