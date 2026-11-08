class_name CameraEffectShake extends CameraEffect
## simple camera shake effect for advanced cameras

@export var noise: FastNoiseLite = FastNoiseLite.new() ## noise that the shake will be sampled from
@export_range(0.0, 1.0, 0.1) var target_trauma := 0.0 ## target trauma
@export_range(0.0, 2.0, 0.1) var shake_intesivity_multipler := 1.0 ## intesivity multipler
@export_range(0.0, 2.0, 0.1) var shake_speed_multipler := 1.0 ## speed multipler
@export_range(0.0, 1.0, 0.1) var shake_smoothness := 7.5 ## smoothness

var trauma := 0.0 ## current trauma

var time := 0.0 ## time
var last_offset := Vector3(0,0,0) ## last offset ( used for shake smoothness )

func apply_shake(value: float): ## used to apply shake ( for explosions etc )
	trauma = clampf(trauma, 0, 1)

func tick(delta: float):
	trauma = lerpf(trauma, target_trauma, min(1.0, 0.75*delta)) # set trauma to smoothly move towards target_trauma
	
	var camera_offset = CameraOffset.new() # create new cameraOffset
	
	time += delta*shake_speed_multipler*trauma # add time
	
	var new_offset = Vector3( # create new vec3
		lerp(last_offset.x, noise.get_noise_1d(time)*trauma*shake_intesivity_multipler, min(1.0, shake_smoothness*120*delta)),
		lerp(last_offset.x, noise.get_noise_1d(time+255.06)*trauma*shake_intesivity_multipler, min(1.0, shake_smoothness*120*delta)),
		lerp(last_offset.x, noise.get_noise_1d(time+2585.25)*trauma*shake_intesivity_multipler, min(1.0, shake_smoothness*120*delta))
	)
	
	camera_offset.rotation_offset = lerp(last_offset, new_offset, shake_smoothness) # camera offset
	
	return camera_offset # return
