shader_type canvas_item;

uniform float whitening;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// Apply node modulate (and any vertex color) first:
	vec4 base = tex * COLOR;

	// Then whiten the RGB toward white:
	base.rgb = mix(base.rgb, vec3(1.0), whitening);

	COLOR = base;
}
