@icon("res://dev_textures/body_part.png")
class_name AdvHealthBodyParts
extends Node
## body part for adv health component

const BLOOD_LIQUID = preload("res://assets/liquids/blood.tres")

@export var health: HealthComponent = HealthComponent.new() ## health component
@export var blood: LiquidContainerComponent = LiquidContainerComponent.new() ## container component
@export var Protection:= 0. ## protection the body part has !!!TO BE IMPLEMENTED!!!
@export var condition_weight:= 1. ## how much the part is important
var drain_per_second: float:
	get():
		return (1.-health.percentage)*5


func get_drain_color():
	return blood.get_liquid_color()

func  _ready() -> void:
	blood.content[BLOOD_LIQUID] = 100.0
	
	
func get_condition_percentage():
	if health.health < 10:
		return 0.
	
	return blood.percentage

func _process(delta: float) -> void:
	if health.health<90: # if health is less than 90 start bleeding
		blood.drain(delta*drain_per_second)
	if health.health>70: # of health is bigger than 70 heal
		health.damage(-delta)
		
	if blood.percentage>.25 and blood.percentage!=7.: # if blood precentage is bigger than 25% start adding blood
		blood.add_liquid(BLOOD_LIQUID, delta*1.5*health.percentage)
