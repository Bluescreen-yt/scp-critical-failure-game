extends ColorRect

@export var blink_shader: ShaderMaterial
@export var blink: FConterComponent
var last_blink = 2.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blink.on_changed.connect(blink_changed)

func blink_changed(value):
	var blink = 6*(1-value/100)-5.5
	last_blink = lerp(last_blink, blink, .75)
	blink_shader.set_shader_parameter("blink", last_blink)
