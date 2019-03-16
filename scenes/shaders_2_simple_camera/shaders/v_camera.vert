
// The camera works by first adding the object position to the vertex position. Next, the camera position 
// is subtracted from that result. Finally, the view size is applied by dividing the resulting x and y by 
// the camera's width and height. 

uniform vec2 objectPosition;
uniform vec2 cameraPosition;
uniform float cameraWidth;
uniform float cameraHeight;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	vec4 vertexClipSpace = vec4(vertex_position.xyz, 1.0);
	
	vertexClipSpace.xy += objectPosition.xy; // Apply object's position offset
	vertexClipSpace.xy -= cameraPosition.xy; // Apply camera object offset (position this vertex relative to the camera)
	
	vertexClipSpace.x /= cameraWidth;
	vertexClipSpace.y /= cameraHeight;
	
	
	return vertexClipSpace; // Returned xyz will be divided by w (1.0) before rasterization
}