shader_type spatial;
#include "res://art/shaders/include/noise.gdshaderinc"
render_mode unshaded;

instance uniform float percentage = 0;
uniform vec4 Uncontrolled : source_color = vec4(0,0.5,0,0.5);
uniform vec4 Controlled : source_color = vec4(0,1.0,0,0.5);

uniform float brightness = 10.0;

uniform vec2 noise_scale = vec2(1,1);
uniform vec2 noise_speed = vec2(0,0);
void vertex() {
	// Called for every vertex the material is visible on.
}


float get_noise(vec2 uv){
	uv += noise_speed * TIME;
	uv *= noise_scale;
	float t = noise_2d(uv);
	return t;
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	if(UV.x > percentage){
		ALBEDO = Uncontrolled.rgb;
		ALPHA = Uncontrolled.a;
	}
	else{
		ALBEDO = Controlled.rgb;
		ALPHA = Controlled.a;
	}
	ALBEDO *= brightness;
	
	ALPHA *= get_noise(UV);
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
