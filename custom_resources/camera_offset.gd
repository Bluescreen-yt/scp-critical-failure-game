class_name CameraOffset extends Resource

@export var rotation_offset :Vector3
@export var position_offset :Vector3

func _add(b: CameraOffset) -> CameraOffset:
	position_offset += b.position_offset
	rotation_offset += b.rotation_offset
	return self
