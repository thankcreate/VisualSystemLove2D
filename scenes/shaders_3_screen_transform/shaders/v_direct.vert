
// Vertex x and y are divided by the camera width and height to maintain a constant size.
// Their final position on the screen is determined by adding the object position.

uniform vec3 objectPosition;
uniform float cameraWidth;
uniform float cameraHeight;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	vec4 vertexClipSpace = vec4(vertex_position.xyz, 1.0);
	
	vertexClipSpace.x /= cameraWidth;
	vertexClipSpace.y /= cameraHeight;
	
	vertexClipSpace.xyz += objectPosition.xyz;
	
	return vertexClipSpace; // Returned xyz will be divided by w (1.0) before rasterization
}