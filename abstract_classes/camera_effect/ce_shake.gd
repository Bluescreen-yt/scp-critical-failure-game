class_name CameraEffectShake extends CameraEffect

var time :float = 0

func tick(delta: float):
	var camera_offset = CameraOffset.new()
	
	# logic here
	time += delta*15
	camera_offset.position_offset.x = time
	
	return camera_offset
