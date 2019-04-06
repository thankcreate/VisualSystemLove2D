-- Create scene root

rootObject = createObject(vector(0, 0))

-- Create stencil-define-group (everything to be drawn to the stencil buffer should be made a child of this object)

groupStencilDefine = createObject(vector(0, 0), rootObject)

groupStencilDefine.canDrawChildren = false -- Turn off automatic drawing of children because children will be drawn in our "stencil function"

function stencilFunction() -- This is the function passed to love2D's stencil drawing implementation

	love.graphics.setDepthMode("lequal", false) -- Turn off writing to depth buffer
	
	groupStencilDefine:drawChildren(groupStencilDefine.camera)
	
	love.graphics.setDepthMode("lequal", true) -- Turn on writing to depth buffer

end

function groupStencilDefine:draw(camera)
	
	groupStencilDefine.camera = camera -- Assign incoming camera so that the stencil function (which has no params) knowns which camera to use
	
    love.graphics.stencil(stencilFunction, "replace", 1) -- "replace", "increment", "decrement", "invert"

end

-- Create an object to be drawn in stencil-define-group (drawn to the stencil buffer)

circleMesh = createMeshCircle(100, 25, WHITE, WHITE)
circleObject = createObjectShape(circleMesh, vector(0, 5, 0), groupStencilDefine)

-- Create object that will turn the stencil test on

objectSetStencilOn = createObject(vector(0, 0), rootObject)

function objectSetStencilOn:draw(camera) love.graphics.setStencilTest("greater", 0) end

-- Create stencil-apply-group (drawn after the stencil test has been turned on)

groupStencilApply = createObject(vector(0, 0), rootObject)

-- Create object that will turn the stencil test off

objectSetStencilOff = createObject(vector(0, 0), rootObject)

function objectSetStencilOff:draw(camera) love.graphics.setStencilTest() end

-- Create mesh/object to draw with the stencil applied (parented under stencil-apply-goup)

rectMesh = createMeshRectangle(-25, 25, 25, -25, BLUE, GREY, GREEN, GREY)
rectObject = createObjectShape(rectMesh, vector(0, 5), groupStencilApply)

rectObject.color:set(1, 0, 0, 0.5) -- Tint the rectangle red!

-- Create text instructions

textLine1 = "THE CIRCLE IS DRAWN TO THE STENCIL BUFFER (AND WRITING TO THE DEPTH BUFFER IS TURNED OFF)\n"
textLine2 = "THEN THE RECTANGLE IS DRAWN, TESTING AGAINST THE STENCIL BUFFER (WHERE THE CIRCLE WAS DRAWN)"

objectText = createObjectText(textLine1 .. textLine2, "center", "center", vector(40, 20), vector(0, -29), rootObject)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2



