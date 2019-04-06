require(globalScenePath .. 'emitter')
require(globalScenePath .. 'particle')

-- Function for making a firework (an object with an emitter)

function createFirework(x, y, color, delay)

	-- Create particle system

	local image = love.graphics.newImage(globalScenePath .. "images/particle1.png")
	local emitter = createFireworkEmitter(image, color)
	
	emitter.timerEmission = delay

	for i = 1, 800 do -- Add particles to custom emitter
		
		emitter:addParticle(createFireworkParticle())
		
	end

	local mesh = createMeshFbx("meshes/hemisphere.fbx")

	emitter:setFireworkShape(mesh)

	-- Create object to update and draw particle system
	
	local object = createObjectEmitter(emitter, vector(x, y), nil)

	object.alphaMode = "alphamultiply"
	object.blendMode = "add" -- Use additive blending (the pixel shader output will ADD to the current pixel values)

end

-- Create dark background

bgColor = color(0.1, 0.1, 0.3, 1)

bgMesh = createMeshRectangle(-38, 38, 0, 30, bgColor, bgColor, bgColor, bgColor)
bgObject = createObjectShape(bgMesh, vector(0, 0, 0), nil)

createFirework(-10, 24, RED, 0.2) 
createFirework(0, 12, WHITE, 1.5) 
createFirework(10, 19, ORANGE, 0.7) 

-- Create description text

line1 = "THE EMITTER AIMS PARTICLES TOWARD THE VERTICES OF A REFERENCE MESH.\n"
line2 = "FOUR PARTICLES ARE LAUNCHED PER VERTEX (FOR A TRAIL EFFECT), ALL ON THE SAME FRAME.\n"
line3 = "THE PARTICLE COLOR BLEND MODE IS ADDITIVE, SO BRIGHTNESS BUILDS AS THEY LAYER."

objectText = createObjectText(line1 .. line2 .. line3, "center", "center", vector(40, 5), vector(0, -19), rootObject)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2