require("lib/globals")

-- Create scene root

rootObject = createObject(vector(0, 0))

-- Create object that will set the new canvas texture

drawSetCanvas = createObject(vector(0, 0), rootObject)

drawSetCanvas.canvas = love.graphics.newCanvas(512, 512)

drawSetCanvas.canvas:setWrap("clamp", "clamp") -- Options include: "clamp", "repeat", "mirroredrepeat" 

function drawSetCanvas:draw(camera)

	love.graphics.setCanvas({ self.canvas, depth = true })
	love.graphics.clear(0.0, 0.0, 0.0, 1)

end

-- Create texture-group (everything to be drawn to the new canvas texture should be made a child of this object)

textureGroup = createObject(vector(0, 0), rootObject)

-- Create object that will reset the canvas after texture-group is finished drawing

drawResetCanvas = createObject(vector(0, 0), rootObject)

function drawResetCanvas:draw(camera)
	
	love.graphics.setCanvas(nil)

end

-- Create scene-group and camera (for drawing the pattern using the canvas texture)

sceneCamera = createObjectCamera(100, vector(0, -5), rootObject)

sceneGroup = createObject(vector(0, 0), rootObject)

sceneGroup.camera = sceneCamera -- Comment out this line to restore default camera to scene group

-- Create an object to be drawn in texture-group (drawn to the canvas texture)

cubeMesh = createMeshFbx("meshes/color_cube.fbx")
cubeObject = createObjectShape(cubeMesh, vector(0, 0, 10), textureGroup)

cubeMesh = createMeshFbx("meshes/file_haha.fbx")
cubeObject = createObjectShape(cubeMesh, vector(0, 0, 10), textureGroup)
local scaleVec = vector(10, 8, 5)
cubeObject.scale = scaleVec


function cubeObject:update(dt)

	-- self:rotateY(dt)

end

-- Create pattern mesh/object to draw the new canvas texture with

patternMesh = createMeshFbx("meshes/pattern_1.fbx")
patternObject = createObjectShape(patternMesh, vector(0, 0), sceneGroup)

patternObject.texture = drawSetCanvas.canvas

-- Create text instructions

textLine1 = "THE PATTERN IS DEFINED BY THE MESH AND ITS UV CONFIGURATION (PRESS 4 TO SEE THE WIREFRAME)\n"
textLine2 = "NAVIGATE THE SCENE WITH DEFAULT CONTROLS TO MANIPULATE THE PATTERN\n"

objectText = createObjectText(textLine1 .. textLine2, "center", "center", vector(40, 20), vector(0, -37), sceneGroup)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2
