require('lib/globals')
require('lib/vector')
require('lib/matrix')
require('lib/color')
require('lib/morph')
require('lib/shader')
require('lib/scenes')
require('lib/texture')
require('lib/particles')
require('lib/interpolate')
require('lib/object_shape')
require('lib/object_text')
require('lib/object_menu')
require('lib/object_camera')
require('lib/object_emitter')
require('lib/console')

function printHelp()
	
	print("NYU Visual Systems 2019 Graphics Library by Chris Makris")
	print("")
	print("PRESS ~ to toggle the console")
	print("PRESS 1 to use ORTHOGRAPHIC PROJECTION and NO depth testing")
	print("PRESS 2 to use PERSPECTIVE PROJECTION with depth testing")
	print("PRESS 3 to toggle depth testing")
	print("PRESS 4 to view wireframes")
	print("PRESS 5 to view filled polygons")
	print("PRESS SPACE to reset camera position/orientation")
	print("")
	print("Ortho - PAN with mouse-right and ZOOM with mouse wheel")
	print("Persp - PAN with mouse-right and FLY with mouse-left and WASD")

end

--------------------------------------------------------------------------------
-- Load: This is where you setup all of your data (meshes, objects, etc.)
--------------------------------------------------------------------------------
function love.load(arg)
	
	-- Create shaders
	
	shaderMesh = createShader("lib/assets/shaders/v_basic.vert", "lib/assets/shaders/f_basic.frag")
	shaderParticle = createShader("lib/assets/shaders/v_particle.vert", "lib/assets/shaders/f_particle.frag")

	-- Create a camera
	
	globalCameraMain = createObjectCamera(100, vector(0, 0, 50))
	
	globalCameraMain.mousePrev = vector(0, 0)
	
	function globalCameraMain:update(dt)
	
		local x, y = love.mouse.getPosition()
		
		local dx = x - self.mousePrev.x 
		local dy = y - self.mousePrev.y 
		
		if love.keyboard.isDown("w") then self:moveLook(-1.0) end
		if love.keyboard.isDown("s") then self:moveLook( 1.0) end
		if love.keyboard.isDown("a") then self:moveRight(-1.0) end
		if love.keyboard.isDown("d") then self:moveRight( 1.0) end
		
		if love.mouse.isDown(1) and self.projectionType == "perspective" and globalMenuMouseClicked == false then
			
			self:rotateY(dx * 0.001)
			self:rotateRight(dy * 0.001)
		
		end
		
		if love.mouse.isDown(2) and globalMenuMouseClicked == false then
			
			self:moveRight(-dx / self.viewScale.x)
			self:moveUp(dy / self.viewScale.y)
		
		end
		
		self.mousePrev.x = x
		self.mousePrev.y = y
	
	end
	
	setupScenes()
	setupConsole()
	printHelp()
	
end

--------------------------------------------------------------------------------
-- Update: This is where you update the transformations of your objects
--------------------------------------------------------------------------------
function love.update(dt)

	if globalObjectRoot then globalObjectRoot:updateChildren(dt) end
	
end

--------------------------------------------------------------------------------
-- Draw: This is where you draw all of your objects
--------------------------------------------------------------------------------
function love.draw(dt)

	love.graphics.clear(0.95, 0.95, 0.95, 1)

	if globalObjectRoot then globalObjectRoot:drawChildren(globalCameraMain) end
	
	if globalConsole.menu then globalConsole.menu:drawChildren(globalConsole.camera) end

end

--------------------------------------------------------------------------------
-- Input: These functions send input information that you can react to
--------------------------------------------------------------------------------
function love.keypressed(key, scancode, isrepeat)
	
	if key == "escape" then
	
		closeActiveScene()
		
	elseif key == "1" then
		
		print("Camera Projection: Orthographic")
		print("Depth Testing: false")
		
		globalUsingDepth = false
		
		if globalCameraMain then globalCameraMain:buildOrthographicProjection() end
		
		love.graphics.setDepthMode("lequal", false)
		
	elseif key == "2" then
		
		print("Camera Projection: Perspective")
		print("Depth Testing: true")
		
		globalUsingDepth = true
		
		if globalCameraMain then globalCameraMain:buildPerspectiveProjection() end
		
		love.graphics.setDepthMode("lequal", true)
		
	elseif key == "3" then
		
		if globalUsingDepth == true then globalUsingDepth = false else globalUsingDepth = true end
		
		love.graphics.setDepthMode("lequal", globalUsingDepth)
		
		print("Depth Testing: " .. tostring(globalUsingDepth))
		
	elseif key == "4" then
	
		love.graphics.setWireframe(true)
		love.graphics.setColorMask(true, true, true, false)
		
	elseif key == "5" then
	
		love.graphics.setWireframe(false)
		love.graphics.setColorMask(true, true, true, true)
		
	elseif key == "space" then
		
		if globalCameraMain then 
		
			-- Reset camera position/orientation
		
			globalCameraMain.position = vector(0, 0, 50)
			
			globalCameraMain.rotationMatrix:identity()
		
		end
		
	end
	
end

function love.wheelmoved(x, y)

	-- Scroll wheel to zoom in and out

	if globalCameraMain.projectionType == "orthographic" then
	
		globalCameraMain:zoom(-y * 3.0)
		
	end

end

--------------------------------------------------------------------------------
-- Resize: Called by love when the window is resized
--------------------------------------------------------------------------------
function love.resize(w, h)
	
	if globalObjectRoot then globalObjectRoot:resizeWindow(w, h) end
  
end