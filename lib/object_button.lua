require('lib/object_text')

-- Create a basic button 

function createObjectButton(text, vecExtents, vecPosition, objParent)

	print("create button")

	local obj = createObject(vecPosition, objParent) -- The object that will be returned
	
	local white = color(1, 1, 1, 1)
	
	obj.type = "button"
	obj.extents = vecExtents
	obj.min = vector(vecPosition.x - vecExtents.x, vecPosition.y - vecExtents.y)
	obj.max = vector(vecPosition.x + vecExtents.x, vecPosition.y + vecExtents.y)
	obj.color = color(0.86, 0.86, 0.86, 1)
	obj.colorHover = color(0.58, 0.58, 0.58, 1)
	obj.colorClick = color(0.66, 0.66, 0.66, 1)
	obj.colorDefault = color(0.86, 0.86, 0.86, 1)
	obj.mesh = createMeshRectangle(-vecExtents.x, vecExtents.x, -vecExtents.y, vecExtents.y, white, white, white, white)
	obj.isClickable = true
	obj.isHovering = false
	obj.isHolding = false
	obj.texture = nil
	obj.shader = shaderMesh
	obj.menu = nil
	obj.textChild = nil
	
	if text then
	
		obj.textChild = createObjectText(text, "center", "center", vectorCopy(vecExtents), vector(0, 0, 1.0), obj)
	
		obj.textChild.canDrawSelf = false
		
	end
	
	function obj:calculateMinMax()
	
		self.min.x = self.worldMatrix[4][1] - (self.extents.x * self.scale.x)
		self.min.y = self.worldMatrix[4][2] - (self.extents.y * self.scale.x) 
		self.max.x = self.worldMatrix[4][1] + (self.extents.x * self.scale.y)
		self.max.y = self.worldMatrix[4][2] + (self.extents.y * self.scale.y)
	
	end
	
	function obj:draw(camera)
		
		if self.menu and self.shader then
			
			-- Draw mesh
			
			if self.mesh then
				
				self:drawMesh(self.mesh)
				
			end
			
			-- Draw text
			
			if self.textChild then
			
				self.textChild:draw(self.menu.camera)
				
			end
	
		end
		
	end
	
	function obj:drawMesh(camera)
		
		-- Start with a copy of this object's world matrix (because we're manipulating it!)
		
		matTemp:copy(self.worldMatrix)
	
		-- Multiply the world matrix copy with the camera's view and projection matrices
	
		matTemp:multiplyAB(self.menu.camera.viewMatrix)
		matTemp:multiplyAB(self.menu.camera.projMatrix)
		
		-- Set and update shader, then draw mesh

		love.graphics.setShader(self.shader.source)
		
		uniformWorldViewProj = matTemp
		uniformColorBlend = self.color
	
		self.shader:updateUniforms()
		
		self.mesh:setTexture(self.texture) -- This is a love2D "mesh" method, but under the hood it's setting a shader uniform
		
		love.graphics.setBlendMode(self.blendMode, self.alphaMode)
		
		love.graphics.draw(self.mesh)
		
	end
	
	function obj:action()
	
		-- Do nothing
	
	end
	
	function obj:click(clickType)
	
		self.color:copy(self.colorClick)
		
		self.isHolding = true
		
	end
	
	function obj:unclick(clickType)
	
		-- If a button is to appear clicked after release, it will "unclick" when another button is clicked
		
	end
	
	function obj:drag(x, y)
	
		-- Drag amount
		
	end
	
	function obj:release(clickType)
	
		self:action()
	
		if self.isHovering == true then
		
			self.color:copy(self.colorHover)
			
		else
		
			self.color:copy(self.colorDefault) 
			
		end
		
		self.isHolding = false
		
	end
	
	function obj:hover()
	
		if self.isHolding == false then self.color:copy(self.colorHover) end
		
		self.isHovering = true
		
	end
	
	function obj:unhover()
	
		if self.isHolding == false then self.color:copy(self.colorDefault) end
		
		self.isHovering = false
		
	end
	
	return obj

end

-- Create a slider button 

function createObjectButtonSlider(vecPosition, width, valMin, valMax, objParent)

	local e = vector(width * 0.5, 0.1)
	local c = color(1, 1, 1, 1)
	
	local meshBar = createMeshRectangle(-e.x, e.x, -e.y, e.y, c, c, c, c)
	local objBar = createObjectShape(meshBar, vecPosition, objParent)
	
	objBar.color = color(1, 1, 1, 1)
	
	local obj = createObjectButton(nil, vector(1, 2), vector(0, 0), objBar)
	
	obj.isHoldingCount = 0
	obj.barWidth = width
	obj.barValMin = valMin
	obj.barValMax = valMax
	obj.clickPosLocal = vector(0, 0)
	obj.clickPosWorld = vector(obj.position.x, obj.position.y)
	
	function obj:update(dt)
	
		if self.isHolding then
		
			self.isHoldingCount = self.isHoldingCount + 1
		
		elseif self.isHoldingCount > 0 then
		
			self.isHoldingCount = 0
		
		end
	
	end
	
	function obj:updateValue(value) -- Override for any specific behavior...
	
		-- print(value)
	
	end
	
	function obj:setValue(value) -- Sets the output value and updates the param value + knob position
	
		local b = self.barValMax - self.barValMin
		local v = value - self.barValMin
		
		self.paramValue = v / b
		self.position.x = (self.paramValue * self.barWidth) - (self.barWidth * 0.5)
		
		self:updateValue(value)
	
	end
	
	function obj:drag(x, y)
	
		local ext = self.barWidth * 0.5
		
		if self.isHoldingCount == 1 then
		
			self.clickPosWorld.x = x
			self.clickPosLocal.x = self.position.x
		
		else
		
			xMove = x - self.clickPosWorld.x -- Offset from point of click
			
			self.position.x = self.clickPosLocal.x + xMove
			
			self.position.x = math.max(self.position.x, -ext)
			self.position.x = math.min(self.position.x,  ext)
			
		end
		
		self.paramValue = (self.position.x + ext) / self.barWidth
		
		local value = (self.barValMin * (1 - self.paramValue)) + (self.barValMax * self.paramValue)
		
		self:updateValue(value)
		
	end
	
	return obj

end