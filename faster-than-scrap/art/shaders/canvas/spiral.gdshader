shader_type canvas_item;

uniform vec4 color: source_color = vec4(1.f);
uniform sampler2D noise;

uniform float spirality = 2.f;
uniform float rot_speed = 2.f;

uniform float speed_to_center = 2.0f;

uniform vec4 alt_color: source_color = vec4(1.f);
uniform float color_change_speed = 1.f;

void vertex() {
	// Called for every vertex the material is visible on.
}

// from cartesian to polar
vec2 polar_coordinates(vec2 uv, vec2 center)
{
	vec2 dir = uv - center;
	float radius = length(dir);
	float angle = atan(dir.y, dir.x) ;
	return vec2(radius, angle);
}

// from polar to cartesian
vec2 cartesian_coordinates(vec2 polar_uv, vec2 center)
{
	float dist = polar_uv.x;
	float angle = polar_uv.y;
	
	vec2 dir = vec2(cos(angle), sin(angle));
	dir *= dist;
	
	return dir + center;
}


void fragment() {
	// Called for every pixel the material is visible on.
	vec2 polar_uv = polar_coordinates(UV.xy, vec2(0.5));
	
	float dist = polar_uv.x;
	float angle = polar_uv.y;
	
	angle += dist * spirality; // create curves
	angle -= TIME * rot_speed; // rotate whole texture
	
	// make it move towards center
	dist += TIME * speed_to_center;
	// to hide noncontinuity it ignores some beginning of the textuer
	dist = mod(dist,5.0f);
	dist += 2.f;
	
	// convert back to cartesian
	vec2 new_polar = vec2(dist,angle);
	vec2 cartesian_cords = cartesian_coordinates(new_polar, vec2(0.5f,0.5f));
	
	cartesian_cords = mod(cartesian_cords,1.f);
	
	COLOR *= texture(noise, cartesian_cords);
	
	// alternate colors
	float t = sin(TIME * color_change_speed)/2.f + 0.5f;
	COLOR *= mix(color, alt_color,t);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
