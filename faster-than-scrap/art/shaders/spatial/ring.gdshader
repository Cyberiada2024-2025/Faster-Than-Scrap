shader_type spatial;
#include "res://art/shaders/include/noise.gdshaderinc"

uniform vec4 color : source_color = vec4(1.0);
uniform float emmision_strength = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float outer_radius = COLOR.x;
	float inner_radius = COLOR.a;
	vec2 pos = UV.xy - vec2(0.5,0.5);
	float dist = distance(pos,vec2(0,0))*2.0;
	
	dist += noise_2d(pos*15.0)/20.0;
	
	if( inner_radius <= dist && dist <= outer_radius ){
		ALPHA = 1.0;
	}
	else{
		ALPHA = 0.0;
	}
	EMISSION = color.rgb * emmision_strength;
	ALBEDO = color.rgb;
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
