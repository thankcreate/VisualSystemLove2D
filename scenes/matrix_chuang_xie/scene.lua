require(globalScenePath .. 'emitter')
require(globalScenePath .. 'particle')

bgColor = color(0.1, 0.1, 0.1, 1)


left = -19
right = 19
top = 35
bottom = -20
-- left = -38
-- right = 38
-- top = 30
-- bottom = 0
width = right - left
height = top - bottom
-- cWidth = width / 2
-- cHeight = height / 2
-- cLeft = left + (width - cWidth) /2
-- cRight = right - (width - cWidth) /2
-- cTop = top - (height - cHeight) / 2
-- cBottom = bottom + (height - cHeight) / 2
cLeft = -5
cRight = 5
cTop = 17
cBottom = 1

cWidth = cRight - cLeft
cHeight = cTop - cBottom

-- -- Create dark background

bgMesh = createMeshRectangle(left, right, top, bottom, bgColor, bgColor, bgColor, bgColor)
bgObject = createObjectShape(bgMesh, vector(0, 0, 0), nil)

-- create a shader
shaderTexSample = createShader("shaders/v_basic.vert", "shaders/f_sample.frag")

uniformTextureOffset = vector(0, 0)
uniformTextureScale = 1.0

function shaderTexSample:updateUniforms() -- Send updated uniforms to the shader

	local s = self.source
	local m = flipMatrix(uniformWorldViewProj) -- Matrix sent to shader needs to be switched from column-major to row-major
	
	if s:hasUniform("worldViewProj") then s:send("worldViewProj", m) end
	if s:hasUniform("textureOffset") then s:send("textureOffset", { uniformTextureOffset.x, uniformTextureOffset.y }) end
	if s:hasUniform("textureScale") then s:send("textureScale", uniformTextureScale) end

end

mesh = createMeshRectangle(left, right, bottom, top, bgColor, bgColor, bgColor, bgColor) -- Create the mesh
-- object = createObjectShape(mesh, vector(0, 0, 0), nil)
object = createObjectShape(mesh, vector(0, 0, -1), nil) -- Create the object (as child of objectRoot)

object.shader = shaderTexSample
object.texture = createTexture("images/bkg2.png", true)

object.texture:setWrap("repeat", "repeat") -- Options include: "clamp", "repeat", "mirroredrepeat" 
object.texture:setFilter("linear", "linear") -- Options include: "nearest", "linear"



-- Function for making a firework (an object with an emitter)
randomCounter = 0
function createFirework(x, y, color, delay, dirX, dirY, destY, needScaleT, particleScale)

	-- Create particle system	
	-- local image = love.graphics.newImage(globalScenePath .. "images/particle1.png")
	local image = love.graphics.newImage(globalScenePath .. "images/zero.png")
	local image2 = love.graphics.newImage(globalScenePath .. "images/one.png")
	
	local emitter = createWallEmitter(image, color, destY)
	local emitter2 = createWallEmitter(image2, color, destY)

	emitter.needScaleTransit = needScaleT
	emitter2.needScaleTransit = needScaleT
	emitter.particleScale = particleScale
	emitter2.particleScale = particleScale
	
	randomCounter = randomCounter + 1
	rem = randomCounter % 2
	
	emitter.timerEmission = delay
	emitter:setDir(dirX, dirY)
	if rem == 1 then
		emitter.innerEmission = emitter.timerEmission / 2
	end

	emitter2.timerEmission = delay
	emitter2:setDir(dirX, dirY)
	if rem == 0 then
		emitter2.innerEmission = emitter2.timerEmission / 2
	end

	for i = 1, 100 do -- Add particles to custom emitter		
		emitter:addParticle(createWallParticle())	
		emitter2:addParticle(createWallParticle())	
	end

	-- Create object to update and draw particle system	
	local object = createObjectEmitter(emitter, vector(x, y), nil)	
	local object2 = createObjectEmitter(emitter2, vector(x, y), nil)

	object.alphaMode = "alphamultiply"
	object.blendMode = "add" -- Use additive blending (the pixel shader output will ADD to the current pixel values)

	object2.alphaMode = "alphamultiply"
	object2.blendMode = "add" -- Use additive blending (the pixel shader output will ADD to the current pixel values)
end

-- Create emitters
speed = 10
interval = 1.5 / speed * 2

HACK_BLUE = color(77/ 255, 192/ 255, 134 / 255, 1)
-- createFirework(0, 24, HACK_BLUE, interval, 0, -speed) 

-- bottom
local step = 1
for i = cLeft, cRight, step / 2 do
	local perc = (i - cLeft) / cWidth

	local destX = width * perc + left
	local destY = bottom

	local diffY = bottom - cBottom
	local diffX = destX - i

	local speedY = -speed
	local speedX = speedY * diffX / diffY

	createFirework(i, cBottom, HACK_BLUE, interval, speedX, speedY, destY, true, vector(0.05, 0.05)) 	
end

-- top
for i = cLeft, cRight, step / 2 do
	local perc = (i - cLeft) / cWidth

	local destX = width * perc + left
	local destY = top

	local diffY = top - cTop
	local diffX = destX - i

	local speedY = speed
	local speedX = speedY * diffX / diffY

	createFirework(i, cTop, HACK_BLUE, interval, speedX, speedY, destY, true, vector(0.05, 0.05)) 		
end

local edgeScaleXEnd = 0.1
local edgeScaleXStart= 0.05
-- right
local ratio = (top - cTop) / (right - cRight)
local ratioBottom = (bottom - cBottom) / (right - cRight)
for i = cRight, right, step do
	local curX = i
	local curY = ratio * (i - cRight) + cTop;

	local destY = ratioBottom * (i - cRight) + cBottom

	local speedY = -speed
	local speedX = 0

	local perc = (i - cRight) / (right - cRight)
	local scaleX = edgeScaleXStart + (edgeScaleXEnd - edgeScaleXStart) * perc
	createFirework(curX, curY, HACK_BLUE, interval, speedX, speedY, destY, false, vector(scaleX, 0.05)) 	
	
end

-- left
ratio = (top - cTop) / (left - cLeft)
ratioBottom = (bottom - cBottom) / (left - cLeft)
for i = cLeft, left, -step do
	local curX = i
	local curY = ratio * (i - cLeft) + cTop;

	local destY = ratioBottom * (i - cLeft) + cBottom

	local speedY = -speed
	local speedX = 0

	local perc = (i - cLeft) / (left - cLeft)
	local scaleX = edgeScaleXStart + (edgeScaleXEnd - edgeScaleXStart) * perc

	createFirework(curX, curY, HACK_BLUE, interval, speedX, speedY, destY, false, vector(scaleX, 0.05)) 	
	
end

-- Create description text

line1 = "TRON XIE 2019\n"
line2 = "THIS IS YOUR LAST CHANCE. AFTER THIS, THERE IS NO TURNING BACK.\nYOU TAKE THE BLUE PILL - THE STORY ENDS, YOU WAKE UP IN YOUR BED AND BELIEVE WHATEVER YOU WANT TO BELIEVE.\n"
line3 = "YOU TAKE THE RED PILL - YOU STAY IN WONDERLAND AND I SHOW YOU HOW DEEP THE RABBIT-HOLE GOES"

objectText = createObjectText(line1 .. line2 .. line3, "center", "center", vector(40, 5), vector(0, -30), rootObject)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2
