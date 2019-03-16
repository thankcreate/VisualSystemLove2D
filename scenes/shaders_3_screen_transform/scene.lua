
-- Create a new shader for drawing vertices directly to image space

shaderDirect = createShader("shaders/v_direct.vert", "shaders/f_direct.frag")

uniformObjectPosition = vector(0, 0, 0)
uniformCameraWidth = 3
uniformCameraHeight = 3

function shaderDirect:updateUniforms() -- Send updated uniforms to the shader

	local s = self.source
	
	if s:hasUniform("objectPosition") then s:send("objectPosition", { uniformObjectPosition.x, uniformObjectPosition.y, uniformObjectPosition.z }) end
	if s:hasUniform("cameraWidth") then s:send("cameraWidth", uniformCameraWidth) end
	if s:hasUniform("cameraHeight") then s:send("cameraHeight", uniformCameraHeight) end

end

-- Create a new shader for regular transformations (transforming an object's world coordinates to image space)

shaderTransform = createShader("shaders/v_basic.vert", "shaders/f_basic.frag")

function shaderTransform:updateUniforms() -- Send updated uniforms to the shader

	local s = self.source
	local m = flipMatrix(uniformWorldViewProj) -- Matrix sent to shader needs to be switched from column-major to row-major
	
	-- The uniformWorldViewProj variable is part of the library, not defined in this file...
	-- It's updated by default in Shape Object's draw() function (take a look!)...
	-- Exactly how it's put together can be seen further down, inside objectVertices:draw(camera)
	
	if s:hasUniform("worldViewProj") then s:send("worldViewProj", m) end 

end

-- Create an object that will draw a mesh (using shaderTransform)

meshTarget = createMeshFbx("meshes/sphere.fbx") -- Create the mesh
objectTarget= createObjectShape(meshTarget, vector(0, 9), nil) -- Create the object (as child of objectRoot)

objectTarget.shader = shaderTransform -- Assign our transformation shader

objectTarget.scale:set(9, 9, 9)

function objectTarget:update(dt)

	self:rotateUp(0.01)
	self:rotateRight(0.005)

end

-- Collect all of meshTarget's vertex positions into table

vertices = {} 

for i = 1, meshTarget:getVertexCount() do

	local x, y, z = meshTarget:getVertex(i)
	
	vertices[i] = { x, y, z } -- These elements are accessed as vertices[i][1], vertices[i][2], vertices[i][3]

end

-- Create an object that will draw a square (directly to image space) for each vertex of the mesh object above

meshRect = createMeshRectangle(-0.1, 0.1, -0.1, 0.1, BLUE, BLUE, BLUE, BLUE) -- Create a mesh for drawing each vertex

objectVertices = createObject(vector(0, 0), nil) -- Create the object 

function objectVertices:draw(camera) -- Override the draw function (it recieves a proper camera object, but we're ignoring it)

	local vec = vector(0, 0, 0)
	local mat = matrix(0, 0, 0)
	
	-- Start with a copy of the target object's world matrix (describing it's position/orientation in space)
	 
	mat:copy(objectTarget.worldMatrix)

	-- Multiply the world matrix with the camera's view and projection matrices (leaving us with a worldViewProjection matrix)

	mat:multiplyAB(camera.viewMatrix)
	mat:multiplyAB(camera.projMatrix)
	
	-- Set the new shader (which draws directly to image space)

	love.graphics.setShader(shaderDirect.source)
	
	uniformCameraWidth = 20
	uniformCameraHeight = uniformCameraWidth * (love.graphics.getHeight() / love.graphics.getWidth())

	for i = 1, #vertices do
		
		local v = vertices[i]
		
		vec:set(v[1], v[2], v[3]) -- Set the vector with xyz coordinates of this vertex
		
		local w = vec:transformPosition(mat) -- Transform the vector coordinates by our combined world + view + projection matrix
		
		-- Now "vec" is a coordinate in image space (also known as clip space). If it's coordinates aren't within -1.0 -> 1.0 then
		-- it exists outside of our image plane and should not be drawn, hence the following "clipping" test:
		
		if (-w <= vec.x and vec.x <= w and -w <= vec.y and vec.y <= w and -w <= vec.z and vec.z <= w) then
		
			-- The final xy values on the screen are determined by what's called the "perspective divide". Each component is
			-- divided by the depth (in relation to the camera). Vertices further from the camera are divided by greater values.
			-- This scaling of triangle points according to depth is a crucial part of the perspective illusion!
			--
			-- * For orthographic projection, the w component will always be 1.
			
			vec.x = vec.x / w -- Scale x position by vertex depth
			vec.y = vec.y / w -- Scale y position by vertex depth
			vec.z = vec.z / w -- Scale z position by vertex depth (* not necessary)
			
			-- * Dividing the vertex z coordinate by the vertex depth doesn't change the xy positon on the screen.
			--   It does, however, affect the depth at which the triangle is understood to exist, which affects
			--   the "depth test" each pixel undergoes to determine whether or not it should be drawn at all.
			
			uniformObjectPosition:copy(vec) -- Update shader uniforms (in this case, with vert's xy image space coordinates)
		
			shaderDirect:updateUniforms() -- Send updated uniforms to the shader
			
			love.graphics.draw(meshRect) -- Draw!
			
		end
	
	end

end

-- Create text instructions (which will be drawn with the default camera + shaders)

textLine1 = "VERTICES ARE DRAWN DIRECTLY TO IMAGE SPACE (NAVIGATE THE SCENE IN 2D OR 3D)\n"

objectText = createObjectText(textLine1, "center", "center", vector(40, 20), vector(0, -20))

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2