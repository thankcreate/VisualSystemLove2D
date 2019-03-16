uniform mat4 worldViewProj;
uniform float time;

varying vec2 imageCoords;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	vec4 vertex_transformed = worldViewProj * vertex_position;
	
	imageCoords = vertex_transformed.xy;
	
	return vertex_transformed;
}