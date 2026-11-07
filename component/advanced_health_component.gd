@icon("res://dev_textures/body.png") class_name AdvancedHealthComponent extends Node

@export var death_message := ""
@export var death_message_timer := -0.1

var body: Dictionary[String, AdvHealthBodyParts] = {}
var condition: float = 100 ## condition
var condition_percentage: float: ## condition percentage ( from 0.0 to 1.0 )
	get():
		return condition/100

func _update_body_list():
	body.clear()
	for body_part in self.get_children():
		if not body_part is AdvHealthBodyParts:
			continue
		
		body[body_part.name] = body_part

func _ready() -> void:
	self.child_order_changed.connect(_update_body_list)
	_update_body_list()

func _process(delta: float) -> void:
	if death_message_timer>=0:
		var new_death_message_timer := death_message_timer-delta
		
		if new_death_message_timer <= 0:
			death_message = ""
			new_death_message_timer = -1
		
		death_message_timer = new_death_message_timer

func damage(amount: float, body_part: String):
	if not body_part in body: printerr(body_part+" does NOT exist.. "); return
	
	var part = body[body_part] as AdvHealthBodyParts
	part.health.damage(amount)
