require('lib/matrix')
require('lib/color')

globalObjectRoot = nil
globalObjectCount = 0

-- Create the base object

matTemp = mat4(0, 0, 0)

function createObject(vecPosition, objParent)

	local obj = {} -- The object that will be returned
	
	globalObjectCount = globalObjectCount + 1

	if globalObjectCount == 1 then -- Add the root object under which all objects are recursively updated/drawn
	
		globalObjectRoot = createObject(vector(0, 0))
		
	end
	
	if objParent == nil then -- If no parent was assigned, parent to global root
	
		objParent = globalObjectRoot
		
	end
	
	if vecPosition == nil then -- If no position vector was assigned, create one at (0, 0)
	
		vecPosition = vector(0, 0)
		
	end
	
	obj.type = "base"
	obj.isEnabled = true
	obj.camera = nil
	obj.canDrawSelf = true
	obj.canDrawChildren = true
	obj.position = vectorCopy(vecPosition)
	obj.extents = vector(1, 1, 1)
	obj.offset = vector(0, 0, 0)
	obj.scale = vector(1, 1, 1)
	obj.color = color(1, 0, 0, 0)
	obj.alpha = 1
	obj.alphaMode = "premultiplied"
	obj.blendMode = "alpha"
	obj.parent = objParent
	obj.children = {}
	obj.childCount = 0
	obj.rotationMatrix = mat4(0, 0, 0)	-- Rotation transform where the object's orientation is stored/manipulated
	obj.worldMatrix = mat4(0, 0, 0)		-- World or "model" transform, the object's final position and orientation in the world
	
	-- Add to scene as child of objParent
	
	if globalObjectRoot then
	
		objParent:addChild(obj)
	
	end
	
	-- Object functions definitions (update() and draw() will commonly be overridden)
	
	function obj:addChild(object) -- Add child object, meaning this object is responsible for updating/drawing it
	
		if object.parent then
		
			if object.parent ~= self then
			
				object.parent:removeChild(object) -- Remove from current parent
				
			end
		
		end
		
		object.parent = self
	
		self.childCount = self.childCount + 1
		
		self.children[self.childCount] = object
	
	end
	
	function obj:removeChild(object) -- Remove child (called by object adding it as child)
	
		local found = 0
		local count = self.childCount
		
		for i = 1, count do 
		
			if found > 0 then
			
				self.children[i - 1] = self.children[i]
				self.children[i] = nil
			
			elseif self.children[i] == object then
				
				found = i
			
				self.children[i] = nil
				
				self.childCount = self.childCount - 1
				
			end
		
		end
	
	end
	
	function obj:updateChildren(dt) -- Recursively update children
	
		for i = 1, self.childCount do 
		
			local child = self.children[i]
		
			if child.isEnabled then 
			
				child:update(dt)
				child:updateWorldMatrix(dt)
				child:updateChildren(dt)
				
			end
			
		end
	
	end
	
	function obj:drawChildren(camera) -- Recursively draw children
	
		for i = 1, self.childCount do 
			
			local child = self.children[i]
			local cam = camera
			
			if child.camera then
			
				cam = child.camera
				
			end
		
			if child.canDrawSelf then
			
				child:draw(cam)
			
			end
			
			if child.canDrawChildren then
			
				child:drawChildren(cam)
				
			end
			
		end
	
	end
	
	function obj:resizeWindow(w, h) -- Recursively update cameras
		
		for i = 1, self.childCount do
		
			local child = self.children[i]
			
			if child.type == "camera" then 
			
				child:onWindowResize(w, h)
				
			end
			
			child:resizeWindow(w, h)
		
		end
	
	end
	
	function obj:onWindowResize(w, h) end -- Function for cameras to fill out
	
	function obj:enable() self.isEnabled = true end
	function obj:disable() self.isEnabled = false end
	
	function obj:show() self.canDrawSelf = true end
	function obj:hide() self.canDrawSelf = false end
	
	function obj:setColorRGBA(r, g, b, a) -- Set object color
	
		self.color.r = r
		self.color.g = g
		self.color.b = b
		self.color.a = a
	
	end
	
	function obj:setPos2D(x, y) -- Set LOCAL position (you don't set WORLD position, it is constructed in updateWorldMatrix())
	
		self.position.x = x
		self.position.y = y
	
	end
	
	function obj:setPos3D(x, y, z) -- Set LOCAL position (you don't set WORLD position, it is constructed in updateWorldMatrix())
	
		self.position.x = x
		self.position.y = y
		self.position.z = z
	
	end
	
	function obj:setScale2D(x, y) -- Set LOCAL scale
	
		self.scale.x = x
		self.scale.y = y
	
	end
	
	function obj:setScale3D(x, y, z) -- Set LOCAL scale
	
		self.scale.x = x
		self.scale.y = y
		self.scale.z = z
	
	end
	
	-- Get offset and extents
	
	function obj:getOffset2D() return self.offset.x, self.offset.y end
	function obj:getOffset3D() return self.offset.x, self.offset.y, self.offset.z end
	
	function obj:getExtents2D() return self.extents.x, self.extents.y end
	function obj:getExtents3D() return self.extents.x, self.extents.y, self.extents.z end
	
	-- Get LOCAL position, scale and right/up/look vectors
	
	function obj:getScale2D() return self.scale.x, self.scale.y end
	function obj:getScale3D() return self.scale.x, self.scale.y, self.scale.z end
	function obj:getPos2D() return self.position.x, self.position.y end
	function obj:getPos3D() return self.position.x, self.position.y, self.position.z end
	function obj:getRight2D() return self.rotationMatrix[1][1], self.rotationMatrix[1][2] end
	function obj:getRight3D() return self.rotationMatrix[1][1], self.rotationMatrix[1][2], self.rotationMatrix[1][3] end
	function obj:getUp2D() return self.rotationMatrix[2][1], self.rotationMatrix[2][2] end
	function obj:getUp3D() return self.rotationMatrix[2][1], self.rotationMatrix[2][2], self.rotationMatrix[2][3] end
	function obj:getLook2D() return self.rotationMatrix[3][1], self.rotationMatrix[3][2] end
	function obj:getLook3D() return self.rotationMatrix[3][1], self.rotationMatrix[3][2], self.rotationMatrix[3][3] end
	
	-- Get WORLD position and right/up/look vectors
	
	function obj:getWorldPos2D() return self.worldMatrix[4][1], self.worldMatrix[4][2] end
	function obj:getWorldPos3D() return self.worldMatrix[4][1], self.worldMatrix[4][2], self.worldMatrix[4][3] end
	function obj:getWorldRight2D() return self.worldMatrix[1][1], self.worldMatrix[1][2] end
	function obj:getWorldRight3D() return self.worldMatrix[1][1], self.worldMatrix[1][2], self.worldMatrix[1][3] end
	function obj:getWorldUp2D() return self.worldMatrix[2][1], self.worldMatrix[2][2] end
	function obj:getWorldUp3D() return self.worldMatrix[2][1], self.worldMatrix[2][2], self.worldMatrix[2][3] end
	function obj:getWorldLook2D() return self.worldMatrix[3][1], self.worldMatrix[3][2] end
	function obj:getWorldLook3D() return self.worldMatrix[3][1], self.worldMatrix[3][2], self.worldMatrix[3][3] end
	
	function obj:moveRight(amount) -- Increment LOCAL position along the LOCAL "right" vector 
	
		self.position.x = self.position.x + (self.rotationMatrix[1][1] * amount)
		self.position.y = self.position.y + (self.rotationMatrix[1][2] * amount)
		self.position.z = self.position.z + (self.rotationMatrix[1][3] * amount)
	
	end
	
	function obj:moveUp(amount) -- Increment LOCAL position along the LOCAL "up" vector 
	
		self.position.x = self.position.x + (self.rotationMatrix[2][1] * amount)
		self.position.y = self.position.y + (self.rotationMatrix[2][2] * amount)
		self.position.z = self.position.z + (self.rotationMatrix[2][3] * amount)
	
	end
	
	function obj:moveLook(amount) -- Increment LOCAL position along the LOCAL "look" vector 
	
		self.position.x = self.position.x + (self.rotationMatrix[3][1] * amount)
		self.position.y = self.position.y + (self.rotationMatrix[3][2] * amount)
		self.position.z = self.position.z + (self.rotationMatrix[3][3] * amount)
	
	end
	
	function obj:moveXY(x, y) -- Increment LOCAL position along a custom vector
	
		self.position.x = self.position.x + x
		self.position.y = self.position.y + y
	
	end
	
	function obj:rotateRight(radians) -- Rotate around the LOCAL "right" vector
	
		matTemp:rotationAxis(radians, self.rotationMatrix[1][1], self.rotationMatrix[1][2], self.rotationMatrix[1][3])
		
		self.rotationMatrix:multiplyAB(matTemp)
	
	end
	
	function obj:rotateUp(radians) -- Rotate around the LOCAL "up" vector
	
		matTemp:rotationAxis(radians, self.rotationMatrix[2][1], self.rotationMatrix[2][2], self.rotationMatrix[2][3])
		
		self.rotationMatrix:multiplyAB(matTemp)
	
	end
	
	function obj:rotateLook(radians) -- Rotate around the LOCAL "look" vector
	
		matTemp:rotationAxis(radians, self.rotationMatrix[3][1], self.rotationMatrix[3][2], self.rotationMatrix[3][3])
		
		self.rotationMatrix:multiplyAB(matTemp)
	
	end
	
	function obj:rotateX(radians) -- Rotate around the GLOBAL "right" vector
	
		matTemp:rotationRight(radians)
		
		self.rotationMatrix:multiplyAB(matTemp)
	
	end
	
	function obj:rotateY(radians) -- Rotate around the GLOBAL "up" vector
	
		matTemp:rotationUp(radians)
		
		self.rotationMatrix:multiplyAB(matTemp)
	
	end
	
	function obj:rotateZ(radians) -- Rotate around the GLOBAL "look" vector
	
		matTemp:rotationLook(radians)
		
		self.rotationMatrix:multiplyAB(matTemp)
	
	end
	
	function obj:update(dt) end -- Function definition
	
	function obj:draw(camera) end -- Function definition
	
	function obj:updateWorldMatrix() -- Update the world matrix with LOCAL position/rotation values * parent transform
	
		-- Start with rotation matrix
		
		self.worldMatrix:copy(self.rotationMatrix)
		
		-- Scale "right" vector of matrix with self.scale.x
		
		self.worldMatrix[1][1] = self.worldMatrix[1][1] * self.scale.x
		self.worldMatrix[1][2] = self.worldMatrix[1][2] * self.scale.x
		self.worldMatrix[1][3] = self.worldMatrix[1][3] * self.scale.x
		
		-- Scale "up" vector of matrix with self.scale.y
		
		self.worldMatrix[2][1] = self.worldMatrix[2][1] * self.scale.y
		self.worldMatrix[2][2] = self.worldMatrix[2][2] * self.scale.y
		self.worldMatrix[2][3] = self.worldMatrix[2][3] * self.scale.y
		
		-- Scale "look" vector of matrix with self.scale.y
		
		self.worldMatrix[3][1] = self.worldMatrix[3][1] * self.scale.z
		self.worldMatrix[3][2] = self.worldMatrix[3][2] * self.scale.z
		self.worldMatrix[3][3] = self.worldMatrix[3][3] * self.scale.z
		
		-- Assign "position" vector of matrix with self.position values
	
		self.worldMatrix[4][1] = self.position.x
		self.worldMatrix[4][2] = self.position.y
		self.worldMatrix[4][3] = self.position.z
		self.worldMatrix[4][4] = 1
		
		if self.parent then
		
			-- Combine with the parent object's world transformation
		
			self.worldMatrix:multiplyAB(self.parent.worldMatrix)
		
		end
	
	end

	return obj

end

