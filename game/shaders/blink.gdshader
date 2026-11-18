shader_type canvas_item;
uniform sampler2D blinkGradient;
uniform sampler2D blinkTopGradient;
uniform sampler2D blinkBottomGradient;
uniform sampler2D noise;
uniform float blink;

#include "util.gdshaderinc"

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 top = texture(blinkTopGradient, vec2(UV.x, UV.y+blink-.5) );
	vec4 bottom = texture(blinkBottomGradient, vec2(UV.x, UV.y-blink+.5) );
	vec4 center = texture(blinkGradient, UV);
	vec4 sum = top*bottom*center;
	sum += texture(noise, UV)*0.1;
	
	sum = ((1.-blink)*0.1+sum-.5)*25.;
	sum = clamp(sum, 0., 1.);
	
	COLOR.rgb = vec3(0);
	COLOR.a = 1.-sum.r;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
