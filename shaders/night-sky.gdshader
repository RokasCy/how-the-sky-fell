shader_type sky;

uniform vec3 topSkyDay : source_color;
uniform vec3 horizonSkyDay : source_color;

uniform vec3 topSkyNight : source_color;
uniform vec3 horizonSkyNight : source_color;

uniform sampler2D noise_texture : filter_nearest, repeat_enable;
const float star_threshold = 0.97;

void sky() {
	float colorGradient = clamp(EYEDIR.y, 0.0, 1);
	vec3 skyColorNight = mix(horizonSkyNight, topSkyNight, colorGradient);
	vec3 color = skyColorNight;
	
	COLOR = color;
}
