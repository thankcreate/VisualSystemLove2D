uniform mat4 worldViewProj;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	vec4 vertex_transformed = worldViewProj * vertex_position;
	
	return vertex_transformed;
}