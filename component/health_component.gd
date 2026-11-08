@icon("res://dev_textures/health.png")
class_name HealthComponent
extends Node
## simple health component

signal onDamaged ## when damaged
signal onDied ## when died
signal onRevived ## when revived

@export var maxHealth := 100.0 ## max health
@export var minHealth := 0.0 ## min health
@export var startWithMaxHealth :bool = true ## start with max health
@export var damageMultipler :float = 1 ## damage multipler
var health : float = 0## current health
var alive : bool = false ## is alive

func _ready() -> void:
	if startWithMaxHealth: ## if start with max health
		health = maxHealth
		alive = true

func damage(amount: float, damage_name: String = "Default") -> void:
	var _nextHealth = health - amount*damageMultipler # new val
	onDamaged.emit(damage_name, amount, health, _nextHealth) # emit damage
	
	if _nextHealth<0 and alive: # if died
		onDied.emit(damage_name, amount)
		alive = false
	
	if _nextHealth>0 and not alive: # if revived
		onRevived.emit(damage_name, amount)
		alive = true
	
	health = clampf(_nextHealth, minHealth, maxHealth) # update val
