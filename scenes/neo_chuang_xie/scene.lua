-- global config
factor = 1
speed = 10  
interval = 1.5 / speed * 2 / factor
overAllScaleFactor = 1 / factor
step = 1 / factor -- step on x


require(globalScenePath .. 'emitter')
require(globalScenePath .. 'particle')
require(globalScenePath .. 'image_analyzer')

bgColor = color(0.1, 0.1, 0.1, 1)


-- canvas property
left = -38
right = 38
top = 32
bottom = -10
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
cLeft = left
cRight = right
cTop = top
cBottom = bottom

cWidth = cRight - cLeft
cHeight = cTop - cBottom

-- -- Create dark background

bgMesh = createMeshRectangle(left, right, top, bottom, bgColor, bgColor, bgColor, bgColor)
bgObject = createObjectShape(bgMesh, vector(0, 0, 0), nil)

-- create a shader
-- shaderTexSample = createShader("shaders/v_basic.vert", "shaders/f_sample.frag")

-- uniformTextureOffset = vector(0, 0)
-- uniformTextureScale = 1.0

-- function shaderTexSample:updateUniforms() -- Send updated uniforms to the shader

-- 	local s = self.source
-- 	local m = flipMatrix(uniformWorldViewProj) -- Matrix sent to shader needs to be switched from column-major to row-major
	
-- 	if s:hasUniform("worldViewProj") then s:send("worldViewProj", m) end
-- 	if s:hasUniform("textureOffset") then s:send("textureOffset", { uniformTextureOffset.x, uniformTextureOffset.y }) end
-- 	if s:hasUniform("textureScale") then s:send("textureScale", uniformTextureScale) end

-- end

-- mesh = createMeshRectangle(left, right, bottom, top, bgColor, bgColor, bgColor, bgColor) -- Create the mesh
-- -- object = createObjectShape(mesh, vector(0, 0, 0), nil)
-- object = createObjectShape(mesh, vector(0, 0, -1), nil) -- Create the object (as child of objectRoot)

-- object.shader = shaderTexSample
-- object.texture = createTexture("images/bkg2.png", true)

-- object.texture:setWrap("repeat", "repeat") -- Options include: "clamp", "repeat", "mirroredrepeat" 
-- object.texture:setFilter("linear", "linear") -- Options include: "nearest", "linear"



-- Function for making a firework (an object with an emitter)
randomCounter = 0
function createFirework(x, y, color, delay, dirX, dirY, destY, needScaleT, particleScale, firstDelayCount)

	-- Create particle system	
	-- local image = love.graphics.newImage(globalScenePath .. "images/particle1.png")
	local image = love.graphics.newImage(globalScenePath .. "images/zero.png")
	local image2 = love.graphics.newImage(globalScenePath .. "images/one.png")
	
	local emitter = createWallEmitter(image, color, destY, firstDelayCount)
	local emitter2 = createWallEmitter(image2, color, destY, firstDelayCount)

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
	emitter.innerEmission = emitter.innerEmission + emitter.firstDelayCount * emitter.timerEmission

	emitter2.timerEmission = delay
	emitter2:setDir(dirX, dirY)
	if rem == 0 then
		emitter2.innerEmission = emitter2.timerEmission / 2
	end
	emitter2.innerEmission = emitter2.innerEmission + emitter2.firstDelayCount * emitter2.timerEmission

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



HACK_BLUE = color(77/ 255, 192/ 255, 134 / 255, 1)
-- createFirework(0, 24, HACK_BLUE, interval, 0, -speed) 

-- bottom


-- center
for i = cLeft, cRight, step * 0.5 do
	local speedY = -speed
	local speedX = 0
	local destY = cBottom
	local rand = math.random()
	rand = 1- rand * rand
	-- local delayCount = math.floor(math.random() / 0.5) / 2
	local delayCount = math.random(1, 10)
	createFirework(i, cTop, HACK_BLUE, interval, speedX, speedY, destY, false, vector(0.05, 0.05), delayCount) 	
end

-- Create description text

line1 = "TRON XIE 2019\n"
line2 = "THIS IS YOUR LAST CHANCE. AFTER THIS, THERE IS NO TURNING BACK.\nYOU TAKE THE BLUE PILL - THE STORY ENDS, YOU WAKE UP IN YOUR BED AND BELIEVE WHATEVER YOU WANT TO BELIEVE.\n"
line3 = "YOU TAKE THE RED PILL - YOU STAY IN WONDERLAND AND I SHOW YOU HOW DEEP THE RABBIT-HOLE GOES"

objectText = createObjectText(line1 .. line2 .. line3, "center", "center", vector(40, 5), vector(0, -20), rootObject)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2
