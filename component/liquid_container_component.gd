@icon("res://dev_textures/liquid_container.png")
class_name LiquidContainerComponent
extends Node
## liquid container !!!UNFINISHED!!!

signal content_changed(new_content:Dictionary[Liquid, float]) ## when conatiner's content changed
signal spill_tick(overflow_amount: float) ## everytime the spill happens

@export var content: Dictionary[Liquid, float] = {}: ## contents of the container
	set(value):
		content = value
		content_changed.emit(value)

@export var max_liquid: float = 100 ## max liquid it can store
@export var enforce_max_liquid: bool = true ## if true it will NOT allow any kind of overflow
@export var spill_per_sec: float = .5 ## how much can the container spill

var percentage: float:
	get():
		return get_total_liquid_units()/max_liquid

func _process(delta: float) -> void:
	if get_total_liquid_units()>max_liquid:
		spill_tick.emit(spill_per_sec*delta*60)


func get_total_liquid_units():
	var units = 0.
	
	for liq: Liquid in content:
		units += content[liq]
	
	return units

func get_liquid_color():
	pass

## TO DO
