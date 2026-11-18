@icon("res://dev_textures/health.png")
class_name HealthComponent
extends Node
## simple health component

signal damaged ## when damaged
signal died ## when died
signal revived ## when revived

@export var max_health := 100.0 ## max health
@export var min_health := 0.0 ## min health
@export var start_with_max_health :bool = true ## start with max health
@export var damage_multipler :float = 1 ## damage multipler

var health : float = 0## current health
var alive : bool = false ## is alive
var percentage : float: ## percentage 1 - 0
	get():
		return health/max_health

func _ready() -> void:
	if start_with_max_health: ## if start with max health
		health = max_health
		alive = true

func damage(amount: float, damage_name: String = "Default") -> void:
	var new_health : float = health - amount*damage_multipler # new val
	damaged.emit(damage_name, amount, health, new_health) # emit damage
	
	if new_health<=0 and alive: # if died
		died.emit(damage_name, amount)
		alive = false
	
	if new_health>0 and not alive: # if revived
		revived.emit(damage_name, amount)
		alive = true
	
	health = clampf(new_health, min_health, max_health) # update val
