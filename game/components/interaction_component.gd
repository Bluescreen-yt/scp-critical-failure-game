@icon("res://dev_textures/interactable.png")
class_name InteractComponent
extends Area3D

## simple component for handling interactions

signal interacted(interaction: Interaction) ## emited when interacted

## get list of interactions
func get_interactions() -> Array[Interaction]:
	var interactions: Array[Interaction] = []
	
	for child in get_children(): # scan for children that are interactable
		if not child is Interaction:
			continue
		
		interactions.append(child)
		
	return interactions

## interact with interaction
func interact(interaction: Interaction) -> void:
	if not interaction in get_interactions(): # check if interaction is child of this object
		print_verbose("not interacting, interaction is not child [%s > %s]" % [interaction.name, interaction.interaction_name])
		return
	
	if interaction.interaction_disabled:
		print_verbose("not interacting, interaction dissabled [%s > %s]" % [interaction.name, interaction.interaction_name])
		return
	
	interaction.interact()
	interacted.emit(interaction)
