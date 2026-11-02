class_name FConterComponent extends Node

signal on_changed
signal on_below_threshold
signal on_above_threshold

@export var max_number := 100.
@export var min_number := 0. 
@export var start_with_max_number :bool = true ## should the counter start at max?
@export var starting_value: float = 0. ## starting value if start_with_max_number is off
@export var change_multipler :float = 1 ## multipler used for change function
@export var threshold :float = 0. ## threshold for below / above value
var value : float ## value
var below_threshold :bool: ## check if value is below or equal to threshold
	get(): return (value<=threshold)


func _ready() -> void:
	if start_with_max_number:
		value = max_number
	else:
		value = starting_value

## change value using this function
func change(amount: float) -> void:
	var new_num = value - amount*change_multipler
	on_changed.emit(new_num)
	
	if new_num<=threshold and not below_threshold:
		on_below_threshold.emit()
	
	if new_num>threshold and below_threshold:
		on_above_threshold.emit()
	
	value = clampf(new_num, min_number, max_number)
