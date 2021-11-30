shader_type canvas_item;

uniform vec2 position;

void fragment(){
	
	vec2 actualPos = position * SCREEN_PIXEL_SIZE;
	
	vec2 xbounds = actualPos.x + vec2(-0.1, 0.1);
	vec2 ybounds = actualPos.y + vec2(-0.1, 0.1);
	
	// Sawtooth time
	float offset = (TIME - floor(TIME))/ TIME;
	float time = TIME * offset;
	vec2 uv = SCREEN_UV;
	
	float xslope = (1.0) / (xbounds.y - xbounds.x);
	float yslope = (1.0) / (ybounds.y - ybounds.x);
	
//	uv.x = SCREEN_UV.x + xslope * (xbounds.y - xbounds.x);
//	uv.y = SCREEN_UV.y + yslope * (ybounds.y - ybounds.x);
	
	// Wave parameters
	vec3 waveParameters = vec3(10.0, 0.8, 0.15);
	
	// Find center
	vec2 center = position * SCREEN_PIXEL_SIZE;
	float centerDist = distance(uv, center);
	
	// Original color
	vec4 oc = texture(SCREEN_TEXTURE, uv);
	
	if (time > 0. && centerDist <= time + waveParameters.z && centerDist >= time - waveParameters.z){
		// Calculate pixel offset
		float diff = (centerDist - time);
		float diffPow = (1.0 - pow(abs(diff * waveParameters.x), waveParameters.y));
		float diffTime = (diff * diffPow);
		
		// Calculate distortion direction
		vec2 dir = normalize(uv - center);
		
		// Perform the distortion and dissipate
		uv += ((dir * diffTime) / (time * centerDist * 10.0));
		
		// Grab new colour
		oc = texture(SCREEN_TEXTURE, uv);
	}
	
	COLOR = vec4(actualPos.y, 0.0, 0.0, 1.0);
	
}