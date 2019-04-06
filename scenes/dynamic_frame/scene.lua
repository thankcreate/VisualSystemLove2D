
-- Create shader

uniformStretchX = 0
uniformStretchY = 0
uniformThickness = 0

shaderFrame = createShader("shaders/v_frame.vert", "shaders/f_frame.frag")

function shaderFrame:updateUniforms()

	local s = self.source
	local m = flipMatrix(uniformWorldViewProj) -- Matrix sent to shader needs to be switched from column-major to row-major

	if s:hasUniform("worldViewProj") then s:send("worldViewProj", m) end
	if s:hasUniform("colorBlend") then s:send("colorBlend", { uniformColorBlend.r, uniformColorBlend.g, uniformColorBlend.b, uniformColorBlend.a }) end
	if s:hasUniform("stretchX") then s:send("stretchX", uniformStretchX) end
	if s:hasUniform("stretchY") then s:send("stretchY", uniformStretchY) end
	if s:hasUniform("thickness") then s:send("thickness", uniformThickness) end
	
end

-- Create meshes

local frame = createMeshFbx("meshes/frame.fbx", "frame")

-- Create scene objects

local objectFrame = createObjectShape(frame, vector(0, 0, 0), nil)

objectFrame.shader = shaderFrame

-- Create menu objects (including a camera)

local camera = createObjectCamera(100, vector(0, 0, 50))

local menu = createObjectMenu(camera)	

local buttonSlider1 = createObjectButtonSlider(vector(-38, 35), 16, 0.0, 50.0, menu)
local buttonSlider2 = createObjectButtonSlider(vector(-38, 25), 16, 0.0, 50.0, menu)
local buttonSlider3 = createObjectButtonSlider(vector(-38, 15), 16, 0.0,  3.0, menu)

function buttonSlider1:updateValue(value) uniformStretchX = value end
function buttonSlider2:updateValue(value) uniformStretchY = value end
function buttonSlider3:updateValue(value) uniformThickness = value end

menu:addButton(buttonSlider1)
menu:addButton(buttonSlider2)
menu:addButton(buttonSlider3)

buttonSlider1:setValue(uniformStretchX)
buttonSlider2:setValue(uniformStretchY)
buttonSlider3:setValue(uniformThickness)
