require('lib/object')

-- Create a camera object

function createObjectCamera(viewWidth, vecPosition, objParent)

	local obj = createObject(vecPosition, objParent) -- The object that will be returned

	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	
	local ratio = height / width
	local viewSize = vector(viewWidth, viewWidth * ratio)
	local scaling = vector(width / viewSize.x, height / viewSize.y) 
	
	obj.type = "camera"
	obj.projectionType = "orthographic"
	obj.viewSize = viewSize
	obj.viewScale = scaling
	obj.viewRatio = ratio
	obj.fov = 90
	obj.z = -100
	obj.near = 1
	obj.far = 1000
	obj.viewMatrix = mat4(0, 0, 0) 		-- View transform, an inversion of the world transform (it moves the world infront of the camera!)
	obj.projMatrix = mat4(0, 0, 0) 		-- Projection transform, which controls how vertices are projected/mapped to screen space
	
	function obj:getMousePos() -- Get the mouse position relative to the camera's view space
		
		local width = love.graphics.getWidth()
		local height = love.graphics.getHeight()
		
		local x, y = love.mouse.getPosition()
		
		x = ((x / width) * 2) - 1.0
		y = ((y / height) * 2) - 1.0
	
		x = x * self.viewSize.x * 0.5
		y = y * -self.viewSize.y * 0.5
		
		x = x + self.position.x
		y = y + self.position.y
		
		return x, y
	
	end
	
	function obj:zoom(amount) -- Zoom the camera in and out (this is just changing the dimensions of the "view")
	
		self:setViewSize(self.viewSize.x + amount)
		
	end
	
	function obj:setFov(degrees)
	
		self.fov = degrees
		
		self:buildPerspectiveProjection()
	
	end
	
	function obj:setViewSize(size) -- Set the view size based on width
	
		self.viewSize.x = size
		self.viewSize.y = size * self.viewRatio
		
		self.viewScale.x = love.graphics.getWidth() / self.viewSize.x
		self.viewScale.y = love.graphics.getHeight() / self.viewSize.y
		
		 -- Rebuild the projection matrix
		
		if self.projectionType == "perspective" then
		
			self:buildPerspectiveProjection()
			
		else
		
			self:buildOrthographicProjection()
		
		end
		
	end
	
	function obj:onWindowResize(w, h) -- Adjust view data to account for new window dimensions
		
		self.viewRatio = h / w
		self.viewSize = vector(self.viewSize.x, self.viewSize.x * self.viewRatio)
		self.viewScale = vector(w / self.viewSize.x, h / self.viewSize.y)
		
		 -- Rebuild the projection matrix
		
		if self.projectionType == "perspective" then
		
			self:buildPerspectiveProjection()
			
		else
		
			self:buildOrthographicProjection()
		
		end
	
	end
	
	function obj:draw(camera) 
	
		-- Do nothing
	
	end
	
	function obj:updateWorldMatrix() -- Update the world matrix from the camera's position and orientation values
	
		-- Start with rotation matrix
		
		self.worldMatrix:copy(self.rotationMatrix)
		
		-- Assign "position" vector of matrix with self.position values
		
		self.worldMatrix[4][1] = self.position.x
		self.worldMatrix[4][2] = self.position.y
		self.worldMatrix[4][3] = self.position.z
		self.worldMatrix[4][4] = 1
		
		if self.parent then
		
			-- Combine with the parent object's world transformation
		
			self.worldMatrix:multiplyAB(self.parent.worldMatrix)
		
		end
		
		-- Update the view matrix
		
		self:updateViewMatrix()
	
	end
	
	function obj:updateViewMatrix() -- Update the view matrix based on the camera's world matrix
		
		local rV = {  self.worldMatrix[1][1],  self.worldMatrix[1][2],  self.worldMatrix[1][3] } -- The right vector
		local uV = {  self.worldMatrix[2][1],  self.worldMatrix[2][2],  self.worldMatrix[2][3] } -- The up vector
		--local lV = { -self.worldMatrix[3][1], -self.worldMatrix[3][2], -self.worldMatrix[3][3] } -- The look vector
		local lV = {  self.worldMatrix[3][1],  self.worldMatrix[3][2],  self.worldMatrix[3][3] } -- The look vector
		local pV = {  self.worldMatrix[4][1],  self.worldMatrix[4][2],  self.worldMatrix[4][3] } -- The position vector

		local x = -((pV[1] * rV[1]) + (pV[2] * rV[2]) + (pV[3] * rV[3])) -- 3D dot product (like the 2D dot function in vector.lua)
		local y = -((pV[1] * uV[1]) + (pV[2] * uV[2]) + (pV[3] * uV[3])) -- 3D dot product
		local z = -((pV[1] * lV[1]) + (pV[2] * lV[2]) + (pV[3] * lV[3])) -- 3D dot product

		self.viewMatrix[1][1] = rV[1]
		self.viewMatrix[1][2] = uV[1]
		self.viewMatrix[1][3] = lV[1]
		self.viewMatrix[1][4] = 0
		
		self.viewMatrix[2][1] = rV[2]
		self.viewMatrix[2][2] = uV[2]
		self.viewMatrix[2][3] = lV[2]
		self.viewMatrix[2][4] = 0
		
		self.viewMatrix[3][1] = rV[3]
		self.viewMatrix[3][2] = uV[3]
		self.viewMatrix[3][3] = lV[3]
		self.viewMatrix[3][4] = 0
		
		self.viewMatrix[4][1] = x	
		self.viewMatrix[4][2] = y
		self.viewMatrix[4][3] = z
		self.viewMatrix[4][4] = 1
		
	end
	
	function obj:buildOrthographicProjection()
	
		local near = 0
		local far = self.far
	
		local tx = 0
		local ty = 0
		local tz = (far + near) / (far - near)

		self.projMatrix[1][1] =  2 / self.viewSize.x
		self.projMatrix[2][1] =  0
		self.projMatrix[3][1] =  0
		self.projMatrix[4][1] =  0
	
		self.projMatrix[1][2] =  0
		self.projMatrix[2][2] =  2 / self.viewSize.y
		self.projMatrix[3][2] =  0
		self.projMatrix[4][2] =  0
		
		self.projMatrix[1][3] =  0
		self.projMatrix[2][3] =  0
		self.projMatrix[3][3] = -2 / (far - near)
		self.projMatrix[4][3] = -tz
		
		self.projMatrix[1][4] =  0
		self.projMatrix[2][4] =  0
		self.projMatrix[3][4] =  0
		self.projMatrix[4][4] =  1
		
		self.projectionType = "orthographic"
	
	end
	
	function obj:buildPerspectiveProjection()
	
		local near = self.near
		local far = self.far
		
		local h = 1.0 / math.tan(self.fov * (math.pi / 360));
		local dist = near - far;
		local nf = near * far;

		self.projMatrix[1][1] =  h
		self.projMatrix[2][1] =  0
		self.projMatrix[3][1] =  0
		self.projMatrix[4][1] = -0
	
		self.projMatrix[1][2] =  0
		self.projMatrix[2][2] =  h / self.viewRatio
		self.projMatrix[3][2] =  0
		self.projMatrix[4][2] =  0
		
		self.projMatrix[1][3] =  0
		self.projMatrix[2][3] =  0
		self.projMatrix[3][3] = (far + near) / dist
		self.projMatrix[4][3] =  2 * (nf) / dist
		
		self.projMatrix[1][4] =  0
		self.projMatrix[2][4] =  0
		self.projMatrix[3][4] = -1
		self.projMatrix[4][4] =  0
		
		self.projectionType = "perspective"
	
	end
		
	 -- Build the projection matrix!
	 
	if obj.projectionType == "perspective" then
	
		obj:buildPerspectiveProjection()
		
	else
	
		obj:buildOrthographicProjection()
	
	end

	return obj

end
