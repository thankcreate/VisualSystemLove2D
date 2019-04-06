uniform mat4 worldViewProj;
uniform float stretchX;
uniform float stretchY;
uniform float thickness;

varying vec2 imageCoords;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	vec4 vertexModified = VertexPosition;
	
	// Scale with B mask
	
	vertexModified.x -= vertexModified.x * (VertexColor.b - 0.5) * thickness;
	vertexModified.y -= vertexModified.y * (VertexColor.b - 0.5) * thickness;
	
	// Translate with R and G masks
	
	vertexModified.x += (VertexColor.r - 0.5) * stretchX;
	vertexModified.y += (VertexColor.g - 0.5) * stretchY;
	
	vec4 vertexTransformed = worldViewProj * vertexModified;
	
	imageCoords = vertexTransformed.xy;
	
	return vertexTransformed;
}