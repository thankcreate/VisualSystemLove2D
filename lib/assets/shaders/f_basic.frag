uniform vec4 colorBlend;
uniform float alpha;

varying vec2 imageCoords;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	float strength = colorBlend.a;

	float inverseStrength = 1 - strength;
	
	vec4 textureColor = Texel(texture, texture_coords);
	vec4 colorFinal;
	
	colorFinal.r = (colorBlend.r * strength) + (color.r * inverseStrength); 	// Lerp red
	colorFinal.g = (colorBlend.g * strength) + (color.g * inverseStrength); 	// Lerp green
	colorFinal.b = (colorBlend.b * strength) + (color.b * inverseStrength); 	// Lerp blue
	colorFinal.a = color.a * alpha;												// Keep vertex alpha

	colorFinal.rgba *= textureColor.rgba;
	
	colorFinal.rgb *= colorFinal.a;
	
	return colorFinal;
} 