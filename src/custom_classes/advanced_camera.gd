@icon("res://dev_textures/camera.png")
class_name AdvancedCamera
extends Camera3D
## advanced camera system

@export var camera_effects :Array[CameraEffect] = [] ## list of effects
@export var base_offset :CameraOffset = CameraOffset.new() ## base offset


func _process(delta: float) -> void:
	var offset = CameraOffset.new()
	
	for effect in camera_effects:
		if not effect is CameraEffect: continue
		
		offset._add(effect.tick(delta))
	
	position = offset.position_offset + base_offset.position_offset
	rotation = offset.rotation_offset + base_offset.rotation_offset
