uniform mat4 worldViewProj;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	vec4 vertexTransformed = worldViewProj * vertex_position;
	
	return vertexTransformed;
}