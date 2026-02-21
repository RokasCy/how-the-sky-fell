shader_type canvas_item;

uniform vec2 window_size;

void fragment() {
    vec2 center = vec2(0.5);
	vec2 uv = UV;
	
	float aspect = window_size.x / window_size.y;
	uv.x = (uv.x - 0.5) * aspect + 0.5;

	
	float dist = distance(uv, center);
	
    //float vignette = smoothstep(0.4, 0.5, dist);
	
	vec4 tex = texture(TEXTURE, UV);
    //COLOR = tex * (1.0 - vignette);
	
	//Black border
	if (dist > 0.5) {
        COLOR = vec4(0.005, 0.005, 0.02, 1.0);
    }
	//edge
	if (dist > 0.498 && dist < 0.502){
		COLOR = vec4(0.8, 0.8, 0.8, 0.5);
	}
	
	//Crosshair
	if (dist < 0.01 && dist > 0.008){
		COLOR = vec4(1.0, 1.0, 1.0, 1.0);
	}
}