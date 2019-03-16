require('lib/object_button')
require('lib/object_menu')

globalConsole = {}

globalConsole.menu = nil
globalConsole.panel = nil
globalConsole.colorPanel = color(0.65, 0.65, 0.65, 1.0)
globalConsole.colorText = color(0.92, 0.92, 0.92, 1.0)
globalConsole.font = love.graphics.newImageFont("lib/assets/images/consolas.png", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=~[]{};':" .. '",.<>?/ \\', -8)

-- Create a console using a custom camera 

function setupConsole()
	
	local width = 100
	local height = 50

	local camera = createObjectCamera(width, vector(0, 0, 0))
	local menu = createObjectMenu(camera)
	
	menu.canDrawChildren = false
	
	local white = color(1, 1, 1, 0.90)
	local mesh = createMeshRectangle(-width * 0.5, width * 0.5, 0, height, white, white, white, white)
	local panel = createObjectShape(mesh, vector(0, 0), menu)
	
	globalConsole.menu = menu
	globalConsole.panel = panel
	
	panel.color:copy(globalConsole.colorPanel)
	
	panel.camera = camera
	panel.screenWidth = love.graphics.getWidth()
	panel.screenHeight = love.graphics.getHeight()
	panel.moveSpeed = 3.0
	panel.moveTimer = 0
	panel.keyTimer = 0
	panel.state = "show"
	
	function panel:update(dt) -- Over-ride update with key detection and console animation
	
		self:updateSize(false)
		
		-- Check for input
	
		if self.keyTimer > 0.25 then
			
			if love.keyboard.isDown("`") then
				
				if self.state == "show" then 
				
					self:hidePanel()
					
				elseif self.state == "hide" then
				
					self:showPanel() 
					
				end
			
			end
			
		else
		
			self.keyTimer = self.keyTimer + dt
			
		end
		
		-- Update state
		
		if self.moveTimer < 1.0 then
		
			self.moveTimer = self.moveTimer + (self.moveSpeed * dt)
			
			if self.moveTimer >= 1.0 then self.moveTimer = 1.0 end
		
			if self.state == "hide" then
				
				self.position.y = lerp(self.moveTimer, self.posShow, self.posHide)
				
				if self.moveTimer >= 1.0 then self.canDrawChildren = false end
			
			elseif self.state == "show" then
				
				self.position.y = lerp(self.moveTimer, self.posHide, self.posShow)
			
			end
		
		end
		
	end
	
	function panel:showPanel()
		
		if self.state ~= "show" then
		
			self.keyTimer = 0
			self.moveTimer = 1 - self.moveTimer
			self.state = "show"
			
			self.canDrawChildren = true
			
		end
		
	end
	
	function panel:hidePanel()
		
		if self.state ~= "hide" then
	
			self.keyTimer = 0
			self.moveTimer = 1 - self.moveTimer
			self.state = "hide"
			
		end
	
	end
	
	function panel:updateSize(force) -- Function for reconfiguring layout when the screen size changes
	
		local screenWidth = love.graphics.getWidth()
		local screenHeight = love.graphics.getHeight()
	
		if self.screenWidth ~= screenWidth or self.screenHeight ~= screenHeight or force == true then
	
			panel.screenWidth = screenWidth
			panel.screenHeight = screenHeight
			
			local viewScreenRatio = self.camera.viewSize.y / screenHeight
			
			self.posHide = self.camera.viewSize.y * 0.5
			self.posShow = self.posHide - (200 * viewScreenRatio)
			
			if self.state == "hide" then 
			
				self.position.y = lerp(self.moveTimer, self.posShow, self.posHide)
			else
			
				self.position.y = lerp(self.moveTimer, self.posHide, self.posShow)
				
			end
			
			for i = 1, #self.children do
			
				local child = self.children[i]
				
				child.position.y = i * (16 * viewScreenRatio) - (3 * viewScreenRatio)
				child.extents.x = (self.camera.viewSize.x * 0.5) - (3 * viewScreenRatio)
			
			end
			
		end
	
	end
	
	function panel:addPrintResult(text) -- Function for setting the lines of text (text data is passed up)

		if #self.children > 0 then
		
			for i = 0, #self.children - 2 do
				
				local top = #self.children - i
				
				self.children[top].text = self.children[top - 1].text
			
			end
			
			self.children[1].text = text
			
		end
	
	end
	
	-- Create the lines of text (as children of panel)

	for i = 1, 12 do
	
		local text1 = createObjectText("line 1", "left", "center", vector(1, 1), vector(0, 0), panel)
		
		text1.font = globalConsole.font
		text1.textFixed = true
		text1.textSize = 0.4
		text1.color:copy(globalConsole.colorText)
		
	end
	
	panel:updateSize(true)
	
end

-- Override Love2D Print() and send data to the new console

function print(...)
	
	local nargs = select("#", ...)
    local args = {}
	
    for i = 1, nargs do
	
        args[i] = tostring((select(i, ...)))
		
    end
	
	if globalConsole and globalConsole.panel then
		
		-- Separate text by new line
		
		local text = table.concat(args, "\t")
		local textLines = {}
		
		for s in text:gmatch("[^\r\n]+") do
		
			table.insert(textLines, s)
			
		end
		
		if #textLines < 1 then -- No newlines, print as found
		
			globalConsole.panel:addPrintResult("+ " .. text)
		
		else
	
			for i = 1, #textLines do
			
				globalConsole.panel:addPrintResult("+ " .. textLines[i])
				
			end
			
		end
		
	end
	
end
