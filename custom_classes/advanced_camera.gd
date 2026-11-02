@icon("res://dev_textures/camera.png") class_name AdvancedCamera extends Camera3D

@export var camera_effects :Array[CameraEffect] = []
@export var base_offset :CameraOffset = null

func _process(delta: float) -> void:
	var offset = CameraOffset.new()
	
	for effect in camera_effects:
		if not effect is CameraEffect: continue
		
		offset._add(effect.tick(delta))
	
	## TO DO
