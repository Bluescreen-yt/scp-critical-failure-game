@icon("res://dev_textures/liquid_container.png")
class_name LiquidContainerComponent
extends Node
## liquid container !!!UNFINISHED!!!

signal content_changed(new_content:Dictionary[Liquid, float]) ## when conatiner's content changed
signal drained(drain_amount: float) ## everytime the container get's drained

@export var content: Dictionary[Liquid, float] = {}: ## contents of the container
	set(value):
		content = value
		content_changed.emit(value)

@export var max_liquid: float = 100 ## max liquid it can store
@export var enforce_max_liquid: bool = true ## if true it will NOT allow any kind of overflow
@export var drain_per_sec: float = .5 ## how much can the container drain


var percentage: float:
	get():
		return get_total_liquid_units()/max_liquid


func _process(delta: float) -> void:
	if get_total_liquid_units()>max_liquid: # if overflows drain it
		drain(drain_per_sec*delta*60)

## drains liquid by amount
func drain(amount: float, liquid_filter: String = "None"):
	drained.emit(amount)
	if liquid_filter=="None":
		var amount_per_liquid = amount/len(content) # TO DO: IMPROVE THIS FUNCTION
		for liquid in content:
			content[liquid] = max(0, content[liquid]-amount_per_liquid)

## adds specific liquid
func add_liquid(liquid:Liquid, amount: float):
	var added := false
	for f_liquid in content: # TO DO: IMPROVE THIS FUNC TOO
		if f_liquid.is_same_as(liquid):
			content[f_liquid] += amount
			added = true
	
	if not added:
		content[liquid] = amount

## gets total liquid
func get_total_liquid_units():
	var units = 0.
	
	for liq: Liquid in content:
		units += content[liq]
	
	return units

## gets avarge of liquid
func get_liquid_color() -> Color:
	var color = Color(0, 0, 0, 0)
	var colors_weight = 0
	
	for f_liquid: Liquid in content: # TO DO: IMPROVE THIS FUNC TOO
		color += f_liquid.color*content[f_liquid]
		colors_weight += content[f_liquid]
	
	return (color/colors_weight).clamp(Color(0, 0, 0, 0), Color.WHITE)
