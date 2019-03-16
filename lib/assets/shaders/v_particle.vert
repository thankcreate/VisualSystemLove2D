uniform mat4 worldViewProj;
uniform float time;

varying vec2 imageCoords;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	vec4 vertex_transformed = worldViewProj * vertex_position;
	
	vertex_transformed.y += time * 0.0; 		// Uniform assignment with zero effect so Love2D doesn't freak out

	imageCoords = vertex_transformed.xy;
	
	return vertex_transformed;
}