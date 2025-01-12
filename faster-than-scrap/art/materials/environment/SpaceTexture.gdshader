shader_type sky;
uniform sampler2D sky_texture;


void sky() {
	COLOR = texture(sky_texture,SKY_COORDS).rgb;
}
