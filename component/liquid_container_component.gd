@icon("res://dev_textures/liquid_container.png") class_name LiquidContainerComponent extends Node

signal content_changed(new_content:Dictionary[Liquid, float])
signal overflow_tick(overflow_amount: float)

@export var content: Dictionary[Liquid, float] = {}:
	set(value):
		content = value
		content_changed.emit(value)

@export var max_liquid: float = 100
@export var enforce_max_liquid: bool = true
@export var overflow_per_sec: float = .5


func _process(delta: float) -> void:
	if get_total_liquid_units()>max_liquid:
		overflow_tick.emit(overflow_per_sec*delta*60)


func get_total_liquid_units():
	var units = 0.
	
	for liq: Liquid in content:
		units += content[liq]
	
	return units

func get_liquid_color():
	pass

## TO DO
