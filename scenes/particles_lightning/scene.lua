require(globalScenePath .. 'emitter')
require(globalScenePath .. 'particle')

-- Create dark background

bgColor = color(0.1, 0.1, 0.3, 1)

bgMesh = createMeshRectangle(-38, 38, 0, 30, bgColor, bgColor, bgColor, bgColor)
bgObject = createObjectShape(bgMesh, vector(0, 0, 0), nil)

-- Create particle system

image = love.graphics.newImage(globalScenePath .. "images/particle3.png")
	
emitter = createLightningEmitter(image)

for i = 1, 800 do -- Add particles to custom emitter
	
	emitter:addParticle(createLightningParticle())
	
end
	
objectLightning = createObjectEmitter(emitter, vector(0, 50), nil)

objectLightning.scale.x = 0.8
objectLightning.scale.y = 0.8

objectLightning.alphaMode = "alphamultiply"
objectLightning.blendMode = "alpha"

-- Create description text

line1 = "THE EMITTER ONLY EMITS THE VERY FIRST PARTICLE UP AT THE TOP.\n"
line2 = "THIS PARTICLE IS RESPONSIBLE FOR EMITTING THE FOLLOWING PARTICLE (AND SO ON...)\n"
line3 = "THUS SQUIGGLY LINES ARE FORMED!"

objectText = createObjectText(line1 .. line2 .. line3, "center", "center", vector(40, 5), vector(0, -19), rootObject)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2
