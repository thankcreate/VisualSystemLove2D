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
function createRain(x, y, color, delay, dirX, dirY, aliveTime, bottomY)

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

end

-- Create emitters
speed = 50
interval = 1.5 / speed  / 1.8
-- interval  = -1

newTop = top + 10
mid = bottom + (newTop  - bottom) * 0.5

for i = left, right + 10, 6 do
	local randomY = math.random() * (40) + top
	-- local randomY = top
	local aliveTime = 20 / speed
	local bottomY = bottom + math.random() * 4
	createRain(i, randomY, WHITE, interval, -speed / 4, -speed, aliveTime, bottomY) 
end


-- Create description text

line1 = "TRON XIE 2019\n"
line2 = "THIS IS YOUR LAST CHANCE. AFTER THIS, THERE IS NO TURNING BACK.\nYOU TAKE THE BLUE PILL - THE STORY ENDS, YOU WAKE UP IN YOUR BED AND BELIEVE WHATEVER YOU WANT TO BELIEVE.\n"
line3 = "YOU TAKE THE RED PILL - YOU STAY IN WONDERLAND AND I SHOW YOU HOW DEEP THE RABBIT-HOLE GOES"

objectText = createObjectText(line1 .. line2 .. line3, "center", "center", vector(40, 5), vector(0, -30), rootObject)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2
