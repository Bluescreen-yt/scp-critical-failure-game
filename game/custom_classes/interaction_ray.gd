#@icon()
class_name InteractionRay
extends RayCast3D

## simple ray for interacting with InteractComponent

signal hovered_over_interactable(object: InteractComponent) ## object = new interact component
signal unhovered_over_interactable(object: InteractComponent) ## object = old interact component
signal hovered_interactable_changed(old_object: InteractComponent, new_object: InteractComponent)

var currently_hovered_interactable: InteractComponent ## InteractComponent

func _ready() -> void: collide_with_areas = true # enable colision with areas

## interact
func interact(interaction: Interaction = null) -> void:
	if currently_hovered_interactable == null:
		print_verbose("nothing to interact with ;)")
		return
	
	if interaction == null:
		print_verbose("interaction is required when interacting with InteractComponent :p, avalible interactions: "+", ".join(currently_hovered_interactable.get_interactions()))
		return
	
	currently_hovered_interactable.interact(interaction)

## get array of avalible interactions
func get_interactions() -> Array[Interaction]:
	if currently_hovered_interactable is InteractComponent:
		return currently_hovered_interactable.get_interactions()
	
	print_verbose("currently_hovered_interactable is NOT InteractComponent")
	return []


func _process(_delta: float) -> void:
	var is_coliding := is_colliding()
	var colided_object := get_collider()
	
	if is_coliding and colided_object is InteractComponent: # check if object can actualy be interacted with ( rigidbody = pick up, InteractionComponent = custom )
		
		if colided_object != currently_hovered_interactable:
			if currently_hovered_interactable!=null: unhovered_over_interactable.emit(currently_hovered_interactable) # if unhovered
			if colided_object!=null: hovered_over_interactable.emit(colided_object) # if hovered
			hovered_interactable_changed.emit(currently_hovered_interactable, colided_object) # if changed
			
			currently_hovered_interactable = colided_object
