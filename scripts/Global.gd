extends Node

var current_scene

var canInput = 0

var starsCount = 0

var isPaused = false

signal set_health(amount)

signal player_attacked(attackDmg)

signal attacked_enemy(lanternDmg)
