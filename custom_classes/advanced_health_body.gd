@icon("res://dev_textures/body_part.png")
class_name AdvHealthBodyParts
extends Node
## body part for adv health component

@export var health: HealthComponent = HealthComponent.new() ## health component
@export var blood: LiquidContainerComponent = LiquidContainerComponent.new() ## container component
@export var Protection:= 0. ## protection the body part has !!!TO BE IMPLEMENTED!!!
@export var condition_weight:= 1. ## how much the part is important

const BLOOD_LIQUID_PATH = "res://assets/liquids/water.tres"

func  _ready() -> void:
	var blood_liquid = load(BLOOD_LIQUID_PATH) as Liquid # set starting liquid to be 100 units blood
	blood.content[blood_liquid] = 100.0

func get_condition_percentage():
	if health.health < 10:
		return 0.
	
	return blood.percentage
