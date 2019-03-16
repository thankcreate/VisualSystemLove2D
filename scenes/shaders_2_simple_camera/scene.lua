
-- Create a new shader

shaderCamera = createShader("shaders/v_camera.vert", "shaders/f_camera.frag")

uniformObjectPosition = vector(0, 0)
uniformCameraPosition = vector(0, 0)
uniformCameraWidth = 3.5
uniformCameraHeight = 3.5

function shaderCamera:updateUniforms() -- Send updated uniforms to the shader

	local s = self.source
	
	if s:hasUniform("objectPosition") then s:send("objectPosition", { uniformObjectPosition.x, uniformObjectPosition.y }) end
	if s:hasUniform("cameraPosition") then s:send("cameraPosition", { uniformCameraPosition.x, uniformCameraPosition.y }) end
	if s:hasUniform("cameraWidth") then s:send("cameraWidth", uniformCameraWidth) end
	if s:hasUniform("cameraHeight") then s:send("cameraHeight", uniformCameraHeight) end

end

-- Create an update object to recieve input that will affect the camera position + view size

objectRoot = createObject(vector(0, 0), nil)

function objectRoot:update(dt)

    -- Control camera position with up/down/left/right

	local distance = 0.005

	if love.keyboard.isDown("up") then uniformCameraPosition.y = uniformCameraPosition.y + distance end
	if love.keyboard.isDown("down") then uniformCameraPosition.y = uniformCameraPosition.y - distance end
	if love.keyboard.isDown("left") then uniformCameraPosition.x = uniformCameraPosition.x - distance end
	if love.keyboard.isDown("right") then uniformCameraPosition.x = uniformCameraPosition.x + distance end
	
	-- Control camera view size with - and + (bigger view size will make your scene smaller!)
	
	if love.keyboard.isDown("=") then uniformCameraWidth = uniformCameraWidth + 0.1 end
	if love.keyboard.isDown("-") then uniformCameraWidth = uniformCameraWidth - 0.1 end
	
	uniformCameraHeight = uniformCameraWidth * (love.graphics.getHeight() / love.graphics.getWidth())

end

-- A function for building a pyrmamid by creating two objects, each of which will draw a triangle (one in light, one in shadow)

function createPyramid(vecPosition, scale)

	-- Create an object that will draw a triangle

	local color1 = color(0.9, 0.8, 0.7, 1)

	local vertices1 = { vector(0 * scale, 0.6 * scale), vector(-0.5 * scale, 0 * scale), vector(0.2 * scale, 0 * scale) }
	local indices1 = { 1, 2, 3 }
	local colors1 = { color1, color1, color1 }

	local mesh1 = createMeshTriangles(vertices1, indices1, colors1) -- Create the mesh
	local object1 = createObjectShape(mesh1, vecPosition, objectRoot) -- Create the object (as child of objectRoot)

	object1.shader = shaderCamera -- Assign the new shader to object1

	function object1:draw(camera) -- Override the draw function (it recieves a proper camera object, but we're ignoring it)
		
		love.graphics.setShader(self.shader.source) -- Set the assigned shader
		
		uniformObjectPosition:copy(self.position) -- Update shader uniforms (in this case, with object's xy position)
		
		self.shader:updateUniforms() -- Send updated uniforms to the shader
		
		love.graphics.draw(self.mesh) -- Draw!

	end

	-- Create another object that will draw a triangle

	local color2 = color(0.8, 0.5, 0.3, 1)

	local vertices2 = { vector(0 * scale, 0.6 * scale), vector(0.2 * scale, 0 * scale), vector(0.45 * scale, 0 * scale) }
	local indices2 = { 1, 2, 3 }
	local colors2 = { color2, color2, color2 }

	local mesh2 = createMeshTriangles(vertices2, indices2, colors2) -- Create the mesh
	local object2 = createObjectShape(mesh2, vecPosition, objectRoot) -- Create the object (as child of objectRoot)

	object2.shader = shaderCamera -- Assign the new shader to object2

	function object2:draw(camera) -- Override the draw function (it recieves a proper camera object, but we're ignoring it)
		
		love.graphics.setShader(self.shader.source) -- Set the assigned shader
		
		uniformObjectPosition:copy(self.position) -- Update shader uniforms (in this case, with object's xy position)
		
		self.shader:updateUniforms() -- Send updated uniforms to the shader
		
		love.graphics.draw(self.mesh) -- Draw!

	end
	
end

-- Create two pyramids!

createPyramid(vector(-0.78, -0.2), 1.0)
createPyramid(vector(0.42, -0.2), 2.0)

-- Create text instructions (which will be drawn with the default camera + shaders)

textLine1 = "THE PYRAMIDS ARE DRAWN USING THEIR OWN SHADER AND CAMERA SYSTEM\n"
textLine2 = "PRESS - AND + TO DECREASE AND INCREASE THE CAMERA VIEW SIZE\n"
textLine3 = "PRESS ARROW KEYS TO MOVE THE CAMERA\n"

objectText = createObjectText(textLine1 .. textLine2 .. textLine3, "center", "center", vector(40, 20), vector(0, -20))

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2
