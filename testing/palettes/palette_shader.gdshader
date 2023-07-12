shader_type canvas_item;

uniform vec3 colors[256] : source_color;

void fragment() {
	// Place fragment code here.
	vec4 sample = texture(TEXTURE, UV);
	int index = int(floor(sample.r * 256.0));
	COLOR = vec4(colors[index % 8], sample.a);
}
