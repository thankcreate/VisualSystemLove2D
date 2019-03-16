
// Sample the texture with a UV scale and UV offset

uniform vec2 textureOffset;
uniform float textureScale;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	vec4 textureColor = Texel(texture, (texture_coords * textureScale) + textureOffset); // The Texel() function samples the texture
	
	return textureColor;
} 