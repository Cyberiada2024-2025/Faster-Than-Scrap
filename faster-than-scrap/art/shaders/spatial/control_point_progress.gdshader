shader_type spatial;

render_mode unshaded;

instance uniform float percentage = 0;
uniform vec4 Uncontrolled : source_color = vec4(0,0.5,0,0.5);
uniform vec4 Controlled : source_color = vec4(0,1.0,0,0.5);


void vertex() {
	// Called for every vertex the material is visible on.
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
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
