class_name FConterComponent extends Node
## simple FLAOT counter

signal on_changed ## when value got changed
signal on_below_threshold ## when value just got below threshold
signal on_above_threshold ## when value just got above threshold

@export var max_number := 100. ## maximum value
@export var min_number := 0.  ## minimal value
@export var start_with_max_number :bool = true ## should the counter start at max?
@export var starting_value: float = 0. ## starting value if start_with_max_number is off
@export var change_multipler :float = 1 ## multipler used for change function
@export var threshold :float = 0. ## threshold for below / above value
var value : float ## value
var below_threshold :bool: ## check if value is below or equal to threshold
	get(): return (value<=threshold)


func _ready() -> void:
	if start_with_max_number: # if starts with max value
		value = max_number # start with max value
	else:
		value = starting_value # if not start with starting value

## change value using this function
func change(amount: float) -> void:
	var new_num = value - amount*change_multipler # new val
	on_changed.emit(new_num)
	
	if new_num<=threshold and not below_threshold: # if just got below threshold
		on_below_threshold.emit()
	
	if new_num>threshold and below_threshold: # if just got above threshold
		on_above_threshold.emit()
	
	value = clampf(new_num, min_number, max_number) # update the value
