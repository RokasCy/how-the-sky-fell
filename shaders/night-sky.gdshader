shader_type sky;

uniform float SunHeight;

uniform vec3 topSkyEarly : source_color;
uniform vec3 horizonSkyEarly : source_color;

uniform vec3 topSkyDay : source_color;
uniform vec3 horizonSkyDay : source_color;

uniform vec3 topSkyNight : source_color;
uniform vec3 horizonSkyNight : source_color;

void sky() {
	float colorGradient = clamp(EYEDIR.y, 0.0, 1);
	vec3 ColorNight = mix(horizonSkyNight, topSkyNight, colorGradient);
	vec3 ColorDay = mix(horizonSkyDay, topSkyDay, colorGradient);
	vec3 ColorEarly = mix(horizonSkyEarly, topSkyEarly, colorGradient);
	vec3 EarlyNight = mix(ColorNight, ColorEarly, SunHeight);
	
	vec3 final = EarlyNight;
	
	COLOR = final;

}
