require("lib/globals")

-- Create scene root

rootObject = createObject(vector(0, 0))

-- Create camera for draw group

camera = createObjectCamera(200, vector(0, 0, 0), rootObject)

-- Create draw group

drawGroup = createObject(vector(0, 0), rootObject)

drawGroup.camera = camera -- Set drawGroup's camera (children will draw with this camera)

-- Create object that will set the low-res canvas under drawGroup

drawSetCanvas = createObject(vector(0, 0), drawGroup)

drawSetCanvas.canvas = love.graphics.newCanvas(16, 16)
--drawSetCanvas.canvas = love.graphics.newCanvas(16, 16, { msaa = 8 } )

drawSetCanvas.canvas:setFilter("nearest", "nearest") -- Don't interpolate sample values (keep pixel edges hard)

function drawSetCanvas:draw(camera)

	love.graphics.setCanvas(self.canvas)
	love.graphics.clear(0.0, 0.0, 0.0, 1)

end

-- Build a mesh with 1 triangle to be drawn onto the new low-res canvas in drawGroup

vertices = {
	--   	  Pos XYZ       Tex UV     Color RGBA   Normal XYZ
        {   -70,  60, 0,    0, 1,    1, 1, 1, 1,    0, 0, 1    }, -- 1  Top left
        {    70,  60, 0,    1, 1,    1, 1, 1, 1,    0, 0, 1    }, -- 2  Top right
        {     0, -60, 0,    1, 0,    1, 1, 1, 1,    0, 0, 1    }, -- 3  Bottom
    }
	
	local attr1 = { "VertexPosition", "float", 3 }
	local attr2 = { "VertexTexCoord", "float", 2 }
	local attr3 = { "VertexColor", "byte", 4 }
	local attr4 = { "VertexNormal", "float", 3 }
	
meshTri = love.graphics.newMesh({ attr1, attr2, attr3, attr4 }, vertices, "triangles", "dynamic")
	
meshTri:setVertexMap(1, 2, 3)
meshTri:setDrawMode("triangles")
	
triObject = createObjectShape(meshTri, vector(0, 0), drawGroup)

-- Create object that will reset the low-res canvas at the end of drawGroup

drawResetCanvas = createObject(vector(0, 0), drawGroup)

function drawResetCanvas:draw(camera)
	
	love.graphics.setCanvas(nil)

end

-- Create scene group (for drawing the canvas texture, a grid, vertex points, triangle edges, text)

sceneGroup = createObject(vector(0, 0), rootObject)

-- Create rectangle to draw low-res canvas texture

size = 25

rectMesh = createMeshRectangle(-size, size, size, -size, WHITE, WHITE, WHITE, WHITE)
rectObject = createObjectShape(rectMesh, vector(0, 0), sceneGroup)

rectObject.texture = drawSetCanvas.canvas

-- Create grid (a series of horizontal and vertical rectanglular meshes)

lineMeshH = createMeshRectangle(-0.1, 0.1, size, -size, WHITE, WHITE, WHITE, WHITE)
lineMeshV = createMeshRectangle(size, -size, 0.1, -0.1, WHITE, WHITE, WHITE, WHITE)

gridSize = 16
gridColor = color(0.1, 0.1, 0.1, 1)

for i = 0, gridSize do

	local lineObjectH = createObjectShape(lineMeshH, vector(((i / gridSize) * size * 2) - size, 0, 0.01), sceneGroup)
	local lineObjectV = createObjectShape(lineMeshV, vector(0, ((i / gridSize) * size * 2) - size, 0.01), sceneGroup)
	
	lineObjectH.color:copy(gridColor)
	lineObjectV.color:copy(gridColor)

end

-- Create 3 objects to represent triangle edges

edgeColor = color(0.6, 0.6, 0.6, 0.7)
edgeMesh = createMeshRectangle(-0.5, 0.5, 0.1, -0.1, edgeColor, edgeColor, edgeColor, edgeColor)

triEdge1 = createObjectShape(edgeMesh, vector(0, 0, 1), sceneGroup)
triEdge2 = createObjectShape(edgeMesh, vector(0, 0, 1), sceneGroup)
triEdge3 = createObjectShape(edgeMesh, vector(0, 0, 1), sceneGroup)

-- Create menu for controlling vertex positions

menu = createObjectMenu(globalCameraMain, sceneGroup)

button1 = createObjectButton("1", vector(0.68, 0.68), vector(-20,  20, 1), sceneGroup)
button2 = createObjectButton("2", vector(0.68, 0.68), vector( 20,  20, 1), sceneGroup)
button3 = createObjectButton("3", vector(0.68, 0.68), vector(  0, -20, 1), sceneGroup)

function button1:drag(x, y)

	self.position.x = x
	self.position.y = y
	
end

function button2:drag(x, y)

	self.position.x = x
	self.position.y = y
	
end

function button3:drag(x, y)

	self.position.x = x
	self.position.y = y
	
end

menu:addButton(button1)
menu:addButton(button2)
menu:addButton(button3)

-- Create object that will update the triangle vertex positions (and edge objects)

triangleUpdater = createObject(vector(0, 0), sceneGroup)

triangleUpdater.menu = menu
triangleUpdater.tri = meshTri
triangleUpdater.b1 = button1
triangleUpdater.b2 = button2
triangleUpdater.b3 = button3
triangleUpdater.edge1 = triEdge1
triangleUpdater.edge2 = triEdge2
triangleUpdater.edge3 = triEdge3

function triangleUpdater:update(dt)

	local nudge = 0

	if love.keyboard.isDown("left") then nudge = -0.2 end
	if love.keyboard.isDown("right") then nudge = 0.2 end
	
	self.b1.position.x = self.b1.position.x + nudge
	self.b2.position.x = self.b2.position.x + nudge
	self.b3.position.x = self.b3.position.x + nudge

	-- Set vertex positions (we're dynamically updating the mesh being rendered to the low-res canvas!)

	local v1 = self.b1.position
	local v2 = self.b2.position
	local v3 = self.b3.position
	
	local sx = 100 / size
	local sy = sx * (love.graphics.getHeight() / love.graphics.getWidth())
	
								--	     Pos XYZ             Tex UV      Color RGBA      Normal XYZ
    self.tri:setVertex(1,    {   v1.x * sx, v1.y * sy, 0,    0, 1,    0, 0.4, 1.0, 1,    0, 0, 1    })
    self.tri:setVertex(2,    {   v2.x * sx, v2.y * sy, 0,    0, 1,    0, 0.4, 1.0, 1,    0, 0, 1    })
    self.tri:setVertex(3,    {   v3.x * sx, v3.y * sy, 0,    0, 1,    0, 0.4, 1.0, 1,    0, 0, 1    })
	
	-- Set the each edge object position/rotation/scale
	
	local dif1 = vectorSubtract(v1, v2)
	local dif2 = vectorSubtract(v2, v3)
	local dif3 = vectorSubtract(v3, v1)
	
	local len1 = length(dif1)
	local len2 = length(dif2)
	local len3 = length(dif3)
	
	self.edge1.scale.x = len1
	self.edge2.scale.x = len2
	self.edge3.scale.x = len3
	
	self.edge1.rotationMatrix[1][1] =  dif1.x / len1
	self.edge1.rotationMatrix[1][2] =  dif1.y / len1
	self.edge1.rotationMatrix[2][1] = -dif1.y / len1
	self.edge1.rotationMatrix[2][2] =  dif1.x / len1
	
	self.edge2.rotationMatrix[1][1] =  dif2.x / len2
	self.edge2.rotationMatrix[1][2] =  dif2.y / len2
	self.edge2.rotationMatrix[2][1] = -dif2.y / len2
	self.edge2.rotationMatrix[2][2] =  dif2.x / len2
	
	self.edge3.rotationMatrix[1][1] =  dif3.x / len3
	self.edge3.rotationMatrix[1][2] =  dif3.y / len3
	self.edge3.rotationMatrix[2][1] = -dif3.y / len3
	self.edge3.rotationMatrix[2][2] =  dif3.x / len3
	
	self.edge1.position.x = (v1.x + v2.x) * 0.5
	self.edge1.position.y = (v1.y + v2.y) * 0.5
	
	self.edge2.position.x = (v2.x + v3.x) * 0.5
	self.edge2.position.y = (v2.y + v3.y) * 0.5
	
	self.edge3.position.x = (v3.x + v1.x) * 0.5
	self.edge3.position.y = (v3.y + v1.y) * 0.5

end

objectText = createObjectText("THE TRIANGLE EXISTS IN A CONTINUOUS VECTOR SPACE\nWHICH MUST BE TRANSLATED TO THE RASTER IMAGE", "center", "center", vector(20, 5), vector(0, -30), rootObject)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2


