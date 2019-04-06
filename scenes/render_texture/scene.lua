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

-- Create an object to be drawn in texture-group (drawn to the canvas texture)

zcubeMesh = createMeshFbx("meshes/color_cube.fbx")
cubeObject = createObjectShape(cubeMesh, vector(0, 0, 10), textureGroup)

function cubeObject:update(dt)

	self:rotateY(dt)

end

-- Create mesh/object to draw the new canvas texture with

size = 25

rectMesh = createMeshRectangle(-size, size, size, -size, WHITE, WHITE, WHITE, WHITE)
rectObject = createObjectShape(rectMesh, vector(0, 5), sceneGroup)

rectObject.texture = drawSetCanvas.canvas

-- Create text instructions

textLine1 = "THE CUBE IS DRAWN TO A TEXTURE (DEFINED BY A LOVE2D 'CANVAS')\n"
textLine2 = "THAT TEXTURE IS THEN DRAWN WITH A PLANE ONTO THE DEFAULT WINDOW TEXTURE"

objectText = createObjectText(textLine1 .. textLine2, "center", "center", vector(40, 20), vector(0, -29), sceneGroup)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2



