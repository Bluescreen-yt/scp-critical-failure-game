@icon("res://dev_textures/battery.png")
class_name BatteryComponent
extends Node
## simple component for batteries

signal fully_charged ## enited when battery just got to 100%
signal empty ## emited when battery is fully drained

@export var max_charge := 100. ## max xharge the battery can hold
var charge := 100. ## current charge
var is_empty :bool: ## is battery empty?
	get():
		return charge==0.
var is_full :bool: ## is battery full?
	get():
		return charge==max_charge
var percentage :float: ## percentage ( from 0 to 1 )
	get():
		return charge/max_charge

## disscharges the battery by amount
func disscharge(amount: float) -> void:
	var new_charge = charge-amount # predict new val
	
	if new_charge==0 and not is_empty: # if battery just got drained
		empty.emit()
	
	if new_charge>=max_charge and not is_full: # if battery just got fully charged
		fully_charged.emit()
	
	charge = clampf(new_charge, 0, max_charge) # update new charge
