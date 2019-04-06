require(globalScenePath .. 'emitter')
require(globalScenePath .. 'particle')

bgColor = color(0.1, 0.1, 0.1, 1)

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

-- Function for making a firework (an object with an emitter)
randomCounter = 0
function createString(x, y, color, delay, dirX, dirY, aliveTime)

	-- Create particle system	
	-- local image = love.graphics.newImage(globalScenePath .. "images/particle1.png")
	local image = love.graphics.newImage(globalScenePath .. "images/zero.png")
	local image2 = love.graphics.newImage(globalScenePath .. "images/one.png")
	
	local emitter = createStringEmitter(image, color, bottom, aliveTime, y)
	local emitter2 = createStringEmitter(image2, color, bottom, aliveTime, y)
	
	randomCounter = randomCounter + 1
	rem = randomCounter % 2
	
	emitter.highlightColor = HIGHLIGHT
	emitter2.highlightColor = HIGHLIGHT


	emitter.timerEmission = delay
	emitter:setDir(dirX, dirY)
	if rem == 0 then
		emitter.innerEmission = emitter.timerEmission / 2
	end

	emitter2.timerEmission = delay
	emitter2:setDir(dirX, dirY)
	if rem == 1 then
		emitter2.innerEmission = emitter2.timerEmission / 2
	end

	for i = 1, 10 do -- Add particles to custom emitter		
		emitter:addParticle(createFireworkParticle())	
		emitter2:addParticle(createFireworkParticle())	
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

newTop = top + 10
mid = bottom + (newTop  - bottom) * 0.5

for i = left, right, 1 do
	local randomY = math.random() * (newTop - mid) + mid
	local aliveTime = math.random() * 5
	createString(i, randomY, HACK_BLUE, interval, 0, -speed, aliveTime) 
end


-- Create description text

line1 = "TRON XIE 2019\n"
line2 = "THIS IS YOUR LAST CHANCE. AFTER THIS, THERE IS NO TURNING BACK.\nYOU TAKE THE BLUE PILL - THE STORY ENDS, YOU WAKE UP IN YOUR BED AND BELIEVE WHATEVER YOU WANT TO BELIEVE.\n"
line3 = "YOU TAKE THE RED PILL - YOU STAY IN WONDERLAND AND I SHOW YOU HOW DEEP THE RABBIT-HOLE GOES"

objectText = createObjectText(line1 .. line2 .. line3, "center", "center", vector(40, 5), vector(0, -30), rootObject)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2
