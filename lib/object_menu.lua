require('lib/object_button')

-- Create a menu system that contains buttons and manages button messaging

globalMenuMouseClicked = false

function createObjectMenu(camera, objParent)

	local obj = createObject(vecPosition, objParent) -- The object that will be returned
	
	obj.type = "menu"
	obj.camera = camera
	obj.buttons = {}
	obj.buttonCount = 0
	obj.buttonClicked = nil
	obj.buttonHovered = nil
	obj.mouseDown = { false, false }
	
	function obj:addButton(button)
	
		self.buttonCount = self.buttonCount + 1
		
		self.buttons[self.buttonCount] = button
		
		button.menu = self
		
		return button
	
	end
	
	function obj:update(dt)
	
		if self.camera then
		
			if self.camera.projectionType == "orthographic" then
		
				-- Test hover
			
				self.camera:updateWorldMatrix()
		
				local width = love.graphics.getWidth()
				local height = love.graphics.getHeight()
				local x, y = love.mouse.getPosition()
				
				x = ((x / width) * 2) - 1.0
				y = ((y / height) * 2) - 1.0
			
				x = x * self.camera.viewSize.x * 0.5
				y = y * -self.camera.viewSize.y * 0.5
				
				x = x + self.camera.position.x
				y = y + self.camera.position.y
				
				local button = self:hover(x, y)
							
				globalMenuMouseClicked = false
				
				-- Test for clicks
				
				for i = 1, 2 do
				
					local isDown = love.mouse.isDown(i)
				
					if isDown then
					
						if self.mouseDown[i] == false then 
					
							self.mouseDown[i] = true
						
							self:click(button, i)
							
						elseif self.buttonClicked then
						
							self.buttonClicked:drag(x, y)
							
							globalMenuMouseClicked = true
						
						end
					
					else
					
						if self.mouseDown[i] == true then
							
							self.mouseDown[i] = false
							
							if self.buttonClicked then 
							
								self.buttonClicked:release(i) 
								
							end
							
						end
							
					end
					
				end
				
			end
		
		end
	
	end
	
	function obj:draw(camera)
	
		-- Do nothing
	
	end
	
	function obj:hover(x, y)
	
		for i = 1, #self.buttons do
		
			local button = self.buttons[i]
			
			if button.isClickable then
			
				button:calculateMinMax()
			
				if x > button.min.x and x < button.max.x and y > button.min.y and y < button.max.y then
				
					if self.buttonHovered == button then
						
						return self.buttonHovered
						
					elseif self.buttonHovered ~= button then
					
						if self.buttonHovered then self.buttonHovered:unhover() end
						
						self.buttonHovered = button
						
						button:hover()
						
						return self.buttonHovered
					
					end
				
				end
				
			end
		
		end
			
		if self.buttonHovered then self.buttonHovered:unhover() end
		
		self.buttonHovered = nil
		
		return nil
	
	end
	
	function obj:click(button, clickType)
	
		if self.buttonClicked and self.buttonClicked ~= button then
		
			self.buttonClicked:unclick(clickType)
		
		end
		
		if button then 
		
			button:click(clickType)
			
		end
		
		self.buttonClicked = button
	
	end

	return obj

end