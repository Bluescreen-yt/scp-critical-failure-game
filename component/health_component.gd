@icon("res://dev_textures/health.png") class_name HealthComponent extends Node

signal onDamaged
signal onDied
signal onRevived

@export var maxHealth := 100.0
@export var minHealth := 0.0
@export var startWithMaxHealth :bool = true
@export var damageMultipler :float = 1
var health : float
var alive : bool = false

func _ready() -> void:
	if startWithMaxHealth:
		health = maxHealth
		alive = true

func damage(amount: float, damage_name: String = "Default") -> void:
	var _nextHealth = health - amount*damageMultipler
	onDamaged.emit(damage_name, amount, health, _nextHealth)
	
	if _nextHealth<0 and alive:
		onDied.emit(damage_name, amount)
		alive = false
	
	if _nextHealth>0 and not alive:
		onRevived.emit(damage_name, amount)
		alive = true
	
	health = clampf(_nextHealth, minHealth, maxHealth)
