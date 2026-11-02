@tool extends ColorRect

@export var shader_noise :FastNoiseLite:
	set(value): update_configuration_warnings(); shader_noise = value
@export var noise_pulse :FastNoiseLite:
	set(value): update_configuration_warnings(); noise_pulse = value
@export var blood_shader :ShaderMaterial:
	set(value): update_configuration_warnings(); blood_shader = value
@export var health_component :AdvancedHealthComponent:
	set(value): update_configuration_warnings(); health_component = value

var TIME := 0.0
var trauma := 1.0

func _get_configuration_warnings() -> PackedStringArray:
	var warnings :PackedStringArray = []
	
	if shader_noise==null: warnings.append("shader_noise IS NOT ASSIGNED")
	if noise_pulse==null: warnings.append("noise_pulse IS NOT ASSIGNED")
	if blood_shader==null: warnings.append("blood_shader IS NOT ASSIGNED")
	if health_component==null: warnings.append("health_component IS NOT ASSIGNED")
	
	return warnings



func _ready() -> void:
	if Engine.is_editor_hint(): return
	if not _get_configuration_warnings().is_empty(): printerr("PLEASE SET REQUIRED VALUES"); return
	
	blood_shader.set_shader_parameter("add", 3)


func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if not _get_configuration_warnings().is_empty(): printerr("PLEASE SET REQUIRED VALUES"); return
	
	var damagePrecentage = 1-health_component.condition_percentage
	trauma = float(int(damagePrecentage*100)^5)*0.04-.75
	
	var current_blood = blood_shader.get_shader_parameter("add")
	var target_blood = (.5-noise_pulse.get_noise_1d(TIME*150)*.25)+(trauma-.75)
	
	TIME += delta*25*(trauma*0.05)
	
	var target_noise_offset = Vector3( noise_pulse.get_noise_1d(TIME*50)*5*trauma, noise_pulse.get_noise_1d(TIME*50+75)*15*trauma, 0 )
	
	shader_noise.offset = lerp(shader_noise.offset, target_noise_offset, clampf(15.*delta, 0., 1.) )
	blood_shader.set_shader_parameter("add", lerpf(current_blood, target_blood, 0.75*delta))
