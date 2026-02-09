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
	
	vec2 uv = (EYEDIR.xz + 1.0) * 2.0;
	float stars = texture(noise_texture, uv).r;
	if (EYEDIR.y > 0.0 && stars > star_threshold){
		color = vec3(1.0);
	}
	COLOR = color;
}
