shader_type spatial;
#include "res://art/shaders/include/noise.gdshaderinc"

uniform float scale = 1.0;
uniform float strength = 1.0;
uniform vec3 direction = vec3(1.0,1.0,1.0);
uniform float speed = 0;

uniform vec4 color : source_color = vec4(1.0);
uniform float color_strength;

uniform float explosion_amount : hint_range(0, 1);
uniform float transparency : hint_range(0, 1);
 
varying float noise;
void vertex() {
	// Called for every vertex the material is visible on.
	vec3 n =  VERTEX.xyz * scale - direction * speed * TIME;
	noise = noise_3d(mod(n,1000));
	VERTEX += NORMAL * strength * noise;
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	if (noise < 1.0 - COLOR.x){
		ALBEDO = color.rgb;
		EMISSION = color.rgb * color_strength;
	}
	else{
		ALBEDO = vec3(0,0,0);
		EMISSION = vec3(0,0,0);
	}
	
	if (noise > COLOR.a){
		ALPHA = 0.0;
	}
	else{
		ALPHA = 1.0;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
