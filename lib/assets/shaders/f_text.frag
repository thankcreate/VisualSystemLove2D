uniform vec4  colorBlend;
uniform float focus;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	vec4 colorSample = Texel(texture, texture_coords);
	
	float a = 0.5 - focus;
	float b = 0.5 + focus;
	
	float maskMain = smoothstep(a, b, colorSample.r);
	
	vec3 colorMain = colorBlend.rgb * maskMain;
	
	vec4 colorFinal = vec4(colorMain.rgb, maskMain);
	
	return colorFinal;
} 