class_name CameraEffectOffset extends CameraEffect
## basic offset effect for advanced cameras

@export var camera_offset :CameraOffset = null ## offset


func tick(_delta: float) -> CameraOffset:
	return camera_offset
