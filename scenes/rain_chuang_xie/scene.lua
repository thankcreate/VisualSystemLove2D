require(globalScenePath .. 'line_emitter')
require(globalScenePath .. 'line_particle')
require(globalScenePath .. 'circle_particle')
require(globalScenePath .. 'circle_emitter')
require(globalScenePath .. 'dot_particle')
require(globalScenePath .. 'dot_emitter')
require(globalScenePath .. 'dirt_particle')
require(globalScenePath .. 'dirt_emitter')


RAIN_HEAVY = 6 -- smaller the heavier
DIRT_HEAVY = 5 -- smaller the heavier
RAIN_DIRECTION_X_DIV = 4 -- infinate means vertical, close to 0 means horizontal

bgColor = color(0.1, 0.1, 0.1, 1)


RAIN_COLOR = color(180 / 255, 180 / 255, 180 / 255, 1)
DIRT_COLOR = color(180 / 255, 180 / 255, 180 / 255, 0.85)


HACK_BLUE = color(77/ 255, 192/ 255, 134 / 255, 1)
HIGHLIGHT = color(250 / 255, 250 / 255, 250 / 255, 1)


left = -38
right = 38
top = 30
bottom = -20
width = right - left
height = top - bottom

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
object.texture = createTexture("images/bkg_rain.png", true)

object.texture:setWrap("repeat", "repeat") -- Options include: "clamp", "repeat", "mirroredrepeat" 
object.texture:setFilter("linear", "linear") -- Options include: "nearest", "linear"




-- Function for making a firework (an object with an emitter)
randomCounter = 0
function createRain(x, y, color, delay, dirX, dirY, aliveTime, bottomY)

	---------- Create rain line
	-- Create particle system	
	-- local image = love.graphics.newImage(globalScenePath .. "images/particle1.png")
	local image = love.graphics.newImage(globalScenePath .. "images/particle3.png")
	
	
	local emitter = createRainEmitter(image, color, bottomY, aliveTime, x, y)
	
	
	emitter.highlightColor = HIGHLIGHT
	emitter.timerEmission = delay
	emitter:setDir(dirX, dirY)

	for i = 1, 1600 do -- Add particles to custom emitter		
		emitter:addParticle(createFireworkParticle())	
	end

	-- Create object to update and draw particle system	
	local object = createObjectEmitter(emitter, vector(x, y), nil)	

	object.alphaMode = "alphamultiply"
	object.blendMode = "add" -- Use additive blending (the pixel shader output will ADD to the current pixel values


	--------- Create rain cirle
	local image2 = love.graphics.newImage(globalScenePath .. "images/circle.png")
	local emitter2 = createCircleEmitter(image2, color, 1.5)

	emitter2.highlightColor = HIGHLIGHT
	emitter2.timerEmission = delay

	for i = 1, 10 do -- Add particles to custom emitter		
		emitter2:addParticle(createCircleParticle())
	end

	
	local object2 = createObjectEmitter(emitter2, vector(x, y), nil)	
	object2.alphaMode = "alphamultiply"
	object2.blendMode = "add" -- Use additive blending (the pixel shader output will ADD to the current pixel values

	emitter.circleEmitter = emitter2
	emitter2.lineEmitter = emitter



	------- Create dot particle
	local image3 = love.graphics.newImage(globalScenePath .. "images/particle4.png")
	local emitter3 = createDotEmitter(image3, color, 0.7)

	emitter3.highlightColor = HIGHLIGHT
	emitter3.timerEmission = delay

	for i = 1, 10 do -- Add particles to custom emitter		
		emitter3:addParticle(createDotParticle())
	end

	
	local object3 = createObjectEmitter(emitter3, vector(x, y), nil)	
	object3.alphaMode = "alphamultiply"
	object3.blendMode = "add" -- Use additive blending (the pixel shader output will ADD to the current pixel values

	emitter.dotEmitter = emitter3
end

function createDirt(x, y, color, delay)

	---------- Create rain line
	-- Create particle system	
	-- local image = love.graphics.newImage(globalScenePath .. "images/particle1.png")
	local image = love.graphics.newImage(globalScenePath .. "images/particle1.png")
	
	
	local emitter = createDirtEmitter(image, color, x, y)
	
	
	emitter.highlightColor = HIGHLIGHT
	emitter.timerEmission = delay	

	for i = 1, 1600 do -- Add particles to custom emitter		
		emitter:addParticle(createDirtParticle())	
	end

	-- Create object to update and draw particle system	
	local object = createObjectEmitter(emitter, vector(x, y), nil)	

	object.alphaMode = "alphamultiply"
	object.blendMode = "add" -- Use additive blending (the pixel shader output will ADD to the current pixel values
end


-- Create emitters
speed = 50
interval = 1.5 / speed  / 1.8
interval  = -1

newTop = top + 10
mid = bottom + (newTop  - bottom) * 0.5

for i = left, right + 10, RAIN_HEAVY do
	local randomY = math.random() * (40) + top
	-- local randomY = top
	local aliveTime = 20 / speed 
	local bottomY = bottom + 2 + math.random() * 4
	createRain(i, randomY, RAIN_COLOR, interval, -speed / RAIN_DIRECTION_X_DIV, -speed, aliveTime, bottomY) 
end

for i = left + 2, right - 2, DIRT_HEAVY do
	local randomY = math.random() * (10) + top
	createDirt(i, randomY, DIRT_COLOR, 3.5) 
end




-- Create description text

line1 = "TRON XIE 2019\n"
line2 = "THIS IS YOUR LAST CHANCE. AFTER THIS, THERE IS NO TURNING BACK.\nYOU TAKE THE BLUE PILL - THE STORY ENDS, YOU WAKE UP IN YOUR BED AND BELIEVE WHATEVER YOU WANT TO BELIEVE.\n"
line3 = "YOU TAKE THE RED PILL - YOU STAY IN WONDERLAND AND I SHOW YOU HOW DEEP THE RABBIT-HOLE GOES"

objectText = createObjectText(line1 .. line2 .. line3, "center", "center", vector(40, 5), vector(0, -30), rootObject)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2
