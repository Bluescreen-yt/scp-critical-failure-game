@icon("res://dev_textures/drop_of_water.png")
class_name Liquid
extends Resource

@export var liquid_name = "water"
@export var mass_per_liqid_unit := 1.
@export var color : Color = Color.BLUE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
