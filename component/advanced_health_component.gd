@icon("res://dev_textures/body.png") class_name AdvancedHealthComponent extends Node

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
