extends Node3D

@onready var recharge_timer = $rechargeTimer
@onready var light = $lanternLight
@onready var flickerLight = $lanternLight/flicker
@onready var recharge_bar = $rechargeLayer/rechargeBar
@onready var label = $labelLayer/Label
@onready var renderBoard = $renderBoard

# total lantern can recover
var totalRecharge = randi_range(7, 20)
# how much the lantern can recover
var lanternPower = randi_range(1, 5)
var cdOver = true
var playerIn = false

# recharge player lantern here

func _process(_delta):
	pass

func _ready():
	# init recharge
	recharge_timer.wait_time = 3
	recharge_timer.start()
	recharge_bar.value = totalRecharge
	recharge_bar.max_value = totalRecharge
	# init label
	var text = "Recharge amount: " + str(totalRecharge) + "\nPower: " + str(lanternPower)
	label.text = text
	
	hideMats()


func lantern_empty():
	$torch2/torch/cnts/fire.hide()
	$fireEmbers.set_emitting(false)
	light.light_energy = 0


func _on_recharge_timer_timeout():
	cdOver = true
	var bodies = $rechargeArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			if totalRecharge > 0:
				print("***RECHARGE AREA ENTERED***")
				
				# get current hp
				var currHP = body.lanternHP
				# find missing hp
				var missingHp = 100 - currHP
				# calculate how much hp to restore
				var rechargeAmt = min(missingHp, lanternPower)
				print("BEFORE RECHARGE... CURRHP : ", currHP, " NEWHP: ", (currHP+rechargeAmt), " RECHARGE LEFT: ", totalRecharge)
				if cdOver:
					# if less than dump the rest
					if totalRecharge >= rechargeAmt:
						body._set_lanternHealth(rechargeAmt)
						totalRecharge -= rechargeAmt
					else:
						body._set_lanternHealth(totalRecharge)
						totalRecharge = 0
					set_recharge_bar(totalRecharge)
					cdOver = false
				print("AFTER RECHARGE... CURRHP : ", currHP, " NEWHP: ", (currHP+rechargeAmt), " RECHARGE LEFT: ", totalRecharge)
		if totalRecharge == 0:
			lantern_empty()


## setters

# set recharge bar
func set_recharge_bar(newVal):
	recharge_bar.value = newVal


## timeouts

# flicker when theres only 1 recharge left
func _on_flicker_timeout():
	if (totalRecharge <= lanternPower) and (totalRecharge > 0):
		if light.light_energy == 0:
			light.light_energy = 10
		else:
			light.light_energy = 0
		flickerLight.wait_time = randf_range(0, 0.5)


func hideMats():
	recharge_bar.visible = false
	label.visible = false


func _on_recharge_area_body_exited(_body):
	hideMats()
	

func _on_area_3d_body_entered(body):	
	# charge left
	if body.is_in_group("player"):
		playerIn = true
		recharge_bar.visible = true
		label.visible = true
		
	if totalRecharge == 0:
		lantern_empty()
	
