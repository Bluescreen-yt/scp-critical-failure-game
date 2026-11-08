shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture,filter_linear_mipmap,repeat_disable;
uniform sampler2D dirty_lens;

vec4 get_bloom(sampler2D screen, vec2 uv, float size, float threshold) {
	return max(vec4(0.), textureLod(screen, uv, size)-threshold );
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 bloom = get_bloom(screen_texture, SCREEN_UV, 3., 0.7);
	bloom += get_bloom(screen_texture, SCREEN_UV, 50., 0.5);
	bloom += get_bloom(screen_texture, SCREEN_UV, 100., 0.3);
	bloom += bloom*(texture(dirty_lens, UV)*2.0);
	
	COLOR = texture(screen_texture, SCREEN_UV) + bloom*.50;
	COLOR.a = 1.0;
}
// Called for every pixel the material is visible on.
//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
