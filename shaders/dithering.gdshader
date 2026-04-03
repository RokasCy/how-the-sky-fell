shader_type canvas_item;

uniform bool preview = false;
uniform sampler2D preview_texture;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float levels = 32.0;
uniform vec2 viewport_resolution = vec2(640.0, 480.0);
uniform vec2 virtual_resolution = vec2(640.0, 480.0);
uniform float dither_strength = 1.0;


const float ditherValue[16] = float[16](
	-4.0, 0.0, -3.0, 1.0,
	2.0, -2.0, 3.0, -1.0,
	-3.0, 1.0, -4.0, 0.0,
	3.0, -1.0, 2.0, -2.0
);

void fragment() {
	vec3 color;
	if (preview){
		 color = texture(preview_texture, UV).rgb;
	}
	else {
		 color = texture(screen_texture, SCREEN_UV).rgb;
	}
	
	int x = int(FRAGCOORD.x * (virtual_resolution.x / viewport_resolution.x)) % 4;
	int y = int(FRAGCOORD.y * (virtual_resolution.y / viewport_resolution.y)) % 4;
	int index = x + y * 4;
	
	float step = 1.0 / (levels - 1.0);
	float n = levels - 1.0;
	float dither_offset = (ditherValue[index] / 8.0) * n * dither_strength;
	
	vec3 new_color = round(color * n + dither_offset) / n;
	
	COLOR = vec4(new_color, 1.0);
}
