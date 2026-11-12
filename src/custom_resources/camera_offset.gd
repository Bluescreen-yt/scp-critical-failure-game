class_name CameraOffset extends Resource
## simple struct

@export var rotation_offset :Vector3 ## rotation offset
@export var position_offset :Vector3 ## position offset

## adds two offsets togheter
func _add(b: CameraOffset) -> CameraOffset:
	position_offset += b.position_offset
	rotation_offset += b.rotation_offset
	return self
