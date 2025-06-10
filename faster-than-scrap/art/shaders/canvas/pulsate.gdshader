shader_type canvas_item;

uniform vec3 default_color : source_color = vec3(1, 0.5, 0);
uniform vec3 pulse_color : source_color = vec3(1, 0, 0);

uniform float period_duration = 1.0f;
uniform float pulse_duration = 0.2f;
uniform float pulse_sharpness = 1.0f;


/*
period 0    |period 1
 /\         | /\
/  \........|/  \...

<----------> period_duration
<--> pulse_duration
*/

void vertex() {
	// Called for every vertex the material is visible on.
	float t = mod(TIME,period_duration);

	if (t < pulse_duration){
		t /= pulse_duration; // normalize to (0,1) values
		// check side of triangle
		if (t < .5f){
			// left side of triangle
			t *= 2.f;
		}
		else{
			// right side of triangle
			t = -2.f*t+2.f;
		}

		t = pow(t,pulse_sharpness); // modify triangle shape
		COLOR.rgb = mix(default_color,pulse_color,t);
	}
	else{
		COLOR.rgb = default_color;
	}

}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
