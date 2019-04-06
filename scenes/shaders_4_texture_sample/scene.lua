
-- Create a new shader

shaderTexSample = createShader("shaders/v_basic.vert", "shaders/f_sample.frag")

uniformTextureOffset = vector(0, 0)
uniformTextureScale = 1.0

function shaderTexSample:updateUniforms() -- Send updated uniforms to the shader

	local s = self.source
	local m = flipMatrix(uniformWorldViewProj) -- Matrix sent to shader needs to be switched from column-major to row-major
	
	if s:hasUniform("worldViewProj") then s:send("worldViewProj", m) end
	if s:hasUniform("textureOffset") then s:send("textureOffset", { uniformTextureOffset.x, uniformTextureOffset.y }) end
	if s:hasUniform("textureScale") then s:send("textureScale", uniformTextureScale) end

end

-- Create an object to respond to input that will control our shader uniforms

root = createObject(vector(0, 0), nil)

function root:update(dt)

	if love.keyboard.isDown("-") then uniformTextureScale = uniformTextureScale - 0.01 end
	if love.keyboard.isDown("=") then uniformTextureScale = uniformTextureScale + 0.01 end
	
	if love.keyboard.isDown("up") then uniformTextureOffset.y = uniformTextureOffset.y + 0.01 end
	if love.keyboard.isDown("down") then uniformTextureOffset.y = uniformTextureOffset.y - 0.01 end
	if love.keyboard.isDown("right") then uniformTextureOffset.x = uniformTextureOffset.x + 0.01 end
	if love.keyboard.isDown("left") then uniformTextureOffset.x = uniformTextureOffset.x - 0.01 end

end

-- Create an object that will draw a mesh (using the default camera system)

mesh = createMeshRectangle(-30, 30, -30, 30, WHITE, WHITE, WHITE, WHITE) -- Create the mesh
object = createObjectShape(mesh, vector(0, 3), nil) -- Create the object (as child of objectRoot)

object.shader = shaderTexSample
object.texture = createTexture("images/pattern.png", true)

object.texture:setWrap("repeat", "repeat") -- Options include: "clamp", "repeat", "mirroredrepeat" 
object.texture:setFilter("linear", "linear") -- Options include: "nearest", "linear"

-- Create text instructions (which will be drawn with the default camera + shaders)

textLine1 = "PRESS - AND + TO SCALE TEXTURE\n"
textLine2 = "USE ARROW KEYS TO OFFSET TEXTURE\n"

objectText = createObjectText(textLine1 .. textLine2, "center", "center", vector(40, 20), vector(0, -33))

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2