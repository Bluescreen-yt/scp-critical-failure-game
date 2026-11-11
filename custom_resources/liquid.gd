@icon("res://dev_textures/drop_of_water.png")
class_name Liquid
extends Resource
## simple liquid resource

@export var liquid_name = "water" ## display name of liquid
@export var mass_per_liqid_unit := 1. ## mass per liquid (weight)
@export var color : Color = Color.BLUE ## color of liquid

func is_same_as(liquid: Liquid):
	if not liquid_name == liquid.liquid_name: return false
	if not mass_per_liqid_unit == liquid.mass_per_liqid_unit: return false
	if not color == liquid.color: return false
	
	return true
