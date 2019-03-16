uniform vec4 colorBlend;
uniform float alpha;

varying vec2 imageCoords;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	vec4 textureColor = Texel(texture, texture_coords);
	
	textureColor.r *= color.r;
	textureColor.g *= color.g;
	textureColor.b *= color.b;
	
	textureColor.rgb = mix(textureColor.rgb, colorBlend.rgb, colorBlend.a);
	
	return textureColor * color.a * alpha;
} 