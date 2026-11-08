shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

uniform sampler2D noise;
uniform sampler2D gradient;
uniform vec4 blood_color: source_color;
uniform float add;

float noiseGradientAdd(sampler2D noiseArg, sampler2D gradientArg , float addArg, vec2 uv) {
	return (texture(noise, uv).r)*0.3+texture(gradient, uv).r+addArg;
}

float threshold(float value, float threshold, float under, float above) {
	if (value>=threshold) {
		return above;
	}
	return under;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float layer1Alpha = threshold(noiseGradientAdd(noise, gradient, add-0.5, UV), 1.0, 0.0, 1.0);
	float layer2Alpha = threshold(noiseGradientAdd(noise, gradient, add-0.6, UV), 1.0, 0.0, 1.0);
	float layer3Alpha = threshold(noiseGradientAdd(noise, gradient, add-0.8, UV), 1.0, 0.0, 1.0);
	float layer4Alpha = threshold(noiseGradientAdd(noise, gradient, add-1., UV), 1.0, 0.0, 1.0);
	float layer5Alpha = threshold(noiseGradientAdd(noise, gradient, add-1.5, UV), 1.0, 0.0, 1.0);
	
	vec3 l1 = blood_color.rgb;
	vec3 l2 = blood_color.rgb*0.9;
	vec3 l3 = blood_color.rgb*0.8;
	vec3 l4 = blood_color.rgb*0.7;
	vec3 l5 = vec3(00);
	
	if (layer1Alpha<1.0) { l1=vec3(1.0); };
	if (layer2Alpha<1.0) { l2=vec3(1.0); };
	if (layer3Alpha<1.0) { l3=vec3(1.0); };
	if (layer4Alpha<1.0) { l4=vec3(1.0); };
	if (layer5Alpha<1.0) { l5=vec3(1.0); };
	
	COLOR.rgb = texture(screen_texture, SCREEN_UV).rgb*l1*l2*l3*l4*l5;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
