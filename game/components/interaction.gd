#@icon()
class_name Interaction
extends Node

## class that stores information about interaction

signal interacted(state: bool) ## emited when interacted

enum InteractionType { ## type of interaction
	BUTTON,
	SWITCH,
}

@export var interaction_name := "Unamed interaction" ## display name
@export var interaction_disabled := false ## is the interaction currently dissabled?
@export var state := false # depends on type of interaction
@export var interaction_type := InteractionType.BUTTON ## type of interaction is it a button or switch?

## interact
func interact() -> void:
	if interaction_disabled: push_warning("can't interact with disabled interaction! [ %s > %s ]" % [self.name, interaction_name] ); return
	
	if interaction_type==InteractionType.SWITCH:
		state = not state
	
	interacted.emit(state)
