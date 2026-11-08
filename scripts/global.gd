extends Node

signal player_blink_changed(status: bool)

@export var player: Player = null
var is_player_blinking = false:
	set(value):
		is_player_blinking = value
		player_blink_changed.emit(value)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
