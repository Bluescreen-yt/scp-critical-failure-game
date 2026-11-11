@icon("res://dev_textures/body.png")
class_name AdvancedHealthComponent
extends Node
## advanced health component to emulate damage per body part


@export var death_message := "" ## death message ( in case player dies, this message will be displayed )
@export var death_message_timer := 1.0 ## timer for death message (-1 turned off)

var body: Dictionary[String, AdvHealthBodyParts] = {} ## list containing body parts
var condition: float = 100 ## condition
var condition_percentage: float: ## condition percentage ( from 0.0 to 1.0 )
	get():
		return condition/100
var drain_per_second: float = 0
var drain_color: Color = Color.BLACK

## updates body parts list
func _update_body_list():
	body.clear() # clear the dictonary
	for body_part in self.get_children(): # for every child in self.children
		if not body_part is AdvHealthBodyParts: # if node is NOT body part skip
			continue
		
		body[body_part.name] = body_part # add it to dict

func _ready() -> void:
	self.child_order_changed.connect(_update_body_list) # everytime children change, update it
	_update_body_list()

func _process(delta: float) -> void:
	condition = 100.
	drain_per_second = 0.
	drain_color = Color(0, 0, 0, 0)
	var drain_color_weight = 0
	var condition_per_part = condition/len(body)
	for part:String in body:
		var part_data: AdvHealthBodyParts = body[part]
		var part_weighted = (condition_per_part*(1-part_data.get_condition_percentage()))*part_data.condition_weight
		condition -= part_weighted
		drain_per_second += part_data.drain_per_second
		
		if part_data.drain_per_second>0:
			drain_color_weight += 1
			drain_color += part_data.get_drain_color()
	
	if drain_color_weight>0:
		drain_color = drain_color/drain_color_weight ## TODO: IMPROVE COLOR LOGIC
	else:
		drain_color = Color(0, 0, 0, 0)
	
	if death_message_timer>=0: # timer logic for death message timer
		var new_death_message_timer := death_message_timer-delta # predict new var
		
		if new_death_message_timer <= 0: # if message is under 0 but was above clear message ( timer timeout )
			death_message = ""
			new_death_message_timer = -1 # also set timer to -1 
		
		death_message_timer = new_death_message_timer # update message timer

## applies damage to specifc body part
func damage(amount: float, body_part: String, death_msg: String = "", death_msg_timer: float = 15):
	if not body_part in body: printerr(body_part+" does NOT exist.. "); return
	
	if not death_msg.is_empty():
		death_message = death_msg
		death_message_timer = death_message_timer
	
	var part = body[body_part] as AdvHealthBodyParts
	part.health.damage(amount)
