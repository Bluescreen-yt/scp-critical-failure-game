@icon("res://dev_textures/body_part.png") class_name AdvHealthBodyParts extends Node

@export var health: HealthComponent = HealthComponent.new()
@export var blood: LiquidContainerComponent = LiquidContainerComponent.new()
@export var Protection:= 0.

const BLOOD_LIQUID_PATH = "res://assets/liquids/water.tres"

func  _ready() -> void:
	var blood_liquid = load(BLOOD_LIQUID_PATH) as Liquid
	blood.content[blood_liquid] = 100.0
