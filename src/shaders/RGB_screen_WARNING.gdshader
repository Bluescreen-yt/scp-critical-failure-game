shader_type canvas_item;
#include "util.gdshaderinc"

// TO DO: improve and make it actual rgb subpixel shader thing


uniform sampler2D screen_texture: hint_screen_texture,filter_linear_mipmap,repeat_disable;
uniform sampler2D screen_rgb_texture: repeat_enable;

uniform float pixel_size = 0.25;


void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 get_glow(vec2 uv, sampler2D base_texture) {
	return max(vec4(0.), textureLod(base_texture, uv, 2.0) - 0.);
}

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	
	vec2 uv = UV * pixel_size * TEXTURE_PIXEL_SIZE*10.0;
	uv -= floor(uv);
	
	color = (color*0.2)+(color*texture(screen_rgb_texture, uv));
	
	vec4 clr_left = get_glow(vec2(-SCREEN_PIXEL_SIZE.x, 0) + SCREEN_UV, screen_texture);
	vec4 clr_right = get_glow(vec2(SCREEN_PIXEL_SIZE.x, 0) + SCREEN_UV, screen_texture);
	vec4 clr_up = get_glow(vec2(0, -SCREEN_PIXEL_SIZE.y) + SCREEN_UV, screen_texture);
	vec4 clr_down = get_glow(vec2(0, SCREEN_PIXEL_SIZE.y) + SCREEN_UV, screen_texture);
	
	vec4 clr_avrg = (clr_left+clr_right+clr_up+clr_down)/4.;
	clr_avrg *= 0.5;
	
	COLOR.rgb = color.rgb+clr_avrg.rgb;
}
