
// This pixel shader simply returns the color (interpolated from each vertex across the triangle)

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	return color;
} 