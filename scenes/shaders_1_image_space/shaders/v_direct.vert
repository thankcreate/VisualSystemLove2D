// This vertex shader returns the position directly, with the 4th component (w) set 
// to 1. The w component (representing depth) is used for the "perspective divide",  
// where each xyz component is automatically divided by w, moving the final vertex   
// output closer to the center of the screen (0, 0). 

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	vec4 vertexClipSpace = vec4(vertex_position.xyz, 1.0);
	
	return vertexClipSpace; // Returned xyz will be divided by w (1.0) before rasterization
}