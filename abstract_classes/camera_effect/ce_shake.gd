class_name CameraEffectShake extends CameraEffect

@export var noise: FastNoiseLite = FastNoiseLite.new()
@export_range(0.0, 1.0, 0.1) var target_trauma := 0.0
@export_range(0.0, 2.0, 0.1) var shake_intesivity_multipler := 1.0
@export_range(0.0, 2.0, 0.1) var shake_peed_multipler := 1.0
@export_range(0.0, 1.0, 0.1) var shake_smoothness := 7.5

var trauma := 0.0

var time := 0.0
var last_offset := Vector3(0,0,0)

func apply_shake(value: float):
	trauma = clampf(trauma, 0, 1)


func tick(delta: float):
	trauma = lerpf(trauma, target_trauma, min(1.0, 0.75*delta))
	
	var camera_offset = CameraOffset.new()
	
	time += delta*shake_peed_multipler
	
	var new_offset = Vector3(
		lerp(last_offset.x, noise.get_noise_1d(time*trauma)*trauma*shake_intesivity_multipler, min(1.0, shake_smoothness*120*delta)),
		lerp(last_offset.x, noise.get_noise_1d(time*trauma+255.06)*trauma*shake_intesivity_multipler, min(1.0, shake_smoothness*120*delta)),
		lerp(last_offset.x, noise.get_noise_1d(time*trauma+2585.25)*trauma*shake_intesivity_multipler, min(1.0, shake_smoothness*120*delta))
	)
	
	camera_offset.rotation_offset = lerp(last_offset, new_offset, shake_smoothness)
	
	return camera_offset
