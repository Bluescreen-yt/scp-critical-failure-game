extends Node

signal player_blink_changed(status: bool)

@export var player: Player = null
var is_player_blinking := false:
	set(value):
		is_player_blinking = value
		player_blink_changed.emit(value)
