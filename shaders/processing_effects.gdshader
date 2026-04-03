shader_type canvas_item;

uniform sampler2D constant_static_texture : repeat_enable, filter_nearest;

void fragment() {
	//vec2 uv = UV + vec2(TIME*0.1, 0.0);
	//vec3 color = texture(constant_static_texture, uv).rgb;
	float n = fract(sin(dot(UV.xy, vec2(12.9898,78.233)) + TIME) * 43758.5453);
	vec3 color = vec3(n);
	//COLOR = vec4(color, 0.3);
}

