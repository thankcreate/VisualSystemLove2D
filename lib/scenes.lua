require('lib/globals')
require('lib/object_menu')
require('lib/object_button')

-- Load a scene path

function loadScene(path)
	
	local info = love.filesystem.getInfo(path)
	local success = false
	
	if info then
		
		local ok, chunk, result
		
		ok, chunk = pcall(love.filesystem.load, path) -- load the chunk safely
		
		if not ok then
		
			print('Scene error: ' .. tostring(chunk))
		  
		else
		
			ok, result = pcall(chunk) -- execute the chunk safely
		 
			if not ok then -- will be false if there is an error
		 
				print('Scene error: ' .. tostring(result))
			
			else
				
				success = true
			
			end
		  
		end
		
	end
	
	return success

end

-- Setup the scene selection menu 

function setupScenes()

	globalSceneMenu = createObjectMenu(globalCameraMain)

	-- Collect the scene folder names
	
	local files = love.filesystem.getDirectoryItems("scenes")
	local folders = {}
	
	if files then
	
		for i = 1, #files do
		
			local folder = files[i]
			
			folders[#folders + 1] = folder
			
		end
		
	end
	
	-- Setup the buttons
	
	local spaceY = 6
	local posY = (#folders - 1) * (spaceY * 0.5)
	local color = color(0.6, 0.7, 0.6, 1)
	
	for i = 1, #folders do
		
		local folder = folders[i]
		local scenePath = "scenes/" .. folder .. "/"

		local button = createObjectButton(folder, vector(16, 2), vector(0, posY), globalSceneMenu)
		
		shiftHue(color, 0.19, 1.0, 1.0)
	
		button.color:copy(color)
		button.colorDefault:copy(color)
		button.colorHover:copy(color)
		button.colorHover:blendRGB(WHITE, 0.15)
		button.textChild.color:copy(color)
		button.textChild.color:blendRGB(WHITE, 0.7)
		button.textChild.textSize = 1.7
		button.textChild.extents.x = 14.8
		button.textChild.justifyX = "left"
		button.scenePath = scenePath
		
		function button:action()
		
			globalScenePath = self.scenePath
		
			local success = loadScene(self.scenePath .. "scene.lua")
			
			globalSceneMenu:disable()
			
			globalSceneMenu.canDrawSelf = false
			globalSceneMenu.canDrawChildren = false
			
			if success then 
			
				globalConsole.panel:hidePanel()
	
				if globalCameraMain then 
				
					-- Reset camera position/orientation
				
					globalCameraMain.position = vector(0, 0, 50)
					
					globalCameraMain.rotationMatrix:identity()
					
					globalCameraMain.projectionType = "orthographic"

					globalCameraMain:setViewSize(100)
					
					globalCameraMain:updateWorldMatrix()
				
				end
				
			end
		
		end
		
		posY = posY - spaceY
		
		globalSceneMenu:addButton(button)
		
	end
		
	
end