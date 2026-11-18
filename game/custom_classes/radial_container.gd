@tool
@icon("res://dev_textures/radial_container.png")
class_name RadialContainer
extends Container

## simple radial container

@export var radius := 250.: ## how far from ceneter the children will be arranged
	set(val):
		radius = val
		_rearange_children()

@export var offset := 0.: ## offset ( deg )
	set(val):
		offset = val
		_rearange_children()

@export var per_element_radius_offset := 0.: ## per element radius offset
	set(val):
		per_element_radius_offset = val
		_rearange_children()

@export var per_element_deg_offset := 0.: ## per element deg offset
	set(val):
		per_element_deg_offset = val
		_rearange_children()

@export var rotate_children := false: ## should children also rotate?
	set(val):
		rotate_children = val
		_rearange_children()

func _ready() -> void:
	child_entered_tree.connect(_rearange_children)
	child_exiting_tree.connect(_rearange_children)
	child_order_changed.connect(_rearange_children)
	resized.connect(_rearange_children)
	
	if get_child_count()>0:
		_rearange_children()

## rearanges children ( ignore x )
func _rearange_children(x = null):
	var center = get_rect().size/2
	
	var deg_space = 360. / get_child_count()
	print("----")
	
	for child: Control in get_children():
		if not child is Control: continue
		
		var angle_deg = deg_space*child.get_index()+(per_element_deg_offset*child.get_index())
		child.position = center+Vector2(radius+(per_element_radius_offset*child.get_index()), 0).rotated(deg_to_rad(angle_deg+offset))
		child.size = child.get_minimum_size()
		
		if rotate_children: 
			child.rotation = deg_to_rad(angle_deg)
		else: 
			child.rotation = 0
		
		print(child.rotation)
