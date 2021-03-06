require("lib/globals")


manualMode = false
time = 0
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



-- Create the clip canvas
drawSetCanvas2 = createObject(vector(0, 0), rootObject)
drawSetCanvas2.canvas = love.graphics.newCanvas(512, 512)
drawSetCanvas2.canvas:setWrap("clamp", "clamp") -- Options include: "clamp", "repeat", "mirroredrepeat" 
function drawSetCanvas2:draw(camera)
	love.graphics.setCanvas({ self.canvas, depth = true })
	love.graphics.clear(0.0, 0.0, 0.0, 1)
end

textureGroup2 = createObject(vector(0, 0), rootObject)

drawResetCanvas2 = createObject(vector(0, 0), rootObject)
function drawResetCanvas2:draw(camera)	
	love.graphics.setCanvas(nil)
end












-- Create scene-group and camera (for drawing the pattern using the canvas texture)

sceneCamera = createObjectCamera(100, vector(0, 0), rootObject)

sceneGroup = createObject(vector(0, 0), rootObject)
sceneGroup.camera = sceneCamera -- Comment out this line to restore default camera to scene group

-- Create an object to be drawn in texture-group (drawn to the canvas texture)

-- cubeMesh = createMeshFbx("meshes/color_cube.fbx")
-- cubeObject = createObjectShape(cubeMesh, vector(0, 0, 10), textureGroup)

pos = vector(0, -16.8)
offset = vector(0, 0)

scale = vector(35, 28, 1) 
-- now the scaleAdjust only adjust the main camera, doesn't effect the object's own scale any more
scaleAdjust = vector(1, 1, 1) 

cubeMesh = createMeshFbx("meshes/file_haha.fbx")
cubeObject = createObjectShape(cubeMesh, vector(pos.x, pos.y, 10), textureGroup)
 
cubeObject.scale = scale
function cubeObject:update(dt)
	self.position = vector(pos.x + offset.x, pos.y + offset.y, 10)
	-- self.scale = vector(scale.x * scaleAdjust.x, scale.y * scaleAdjust.y, scale.z * scaleAdjust.z)
end

clipOffset = vector(0, 0);
cubeMeshClip = createMeshFbx("meshes/file_haha.fbx")
cubeObjectClip = createObjectShape(cubeMeshClip, vector(pos.x, pos.y, 10), textureGroup2)
cubeObjectClip.scale = scale

function cubeObjectClip:update(dt)
	self.position = vector(pos.x + offset.x, pos.y + offset.y, 10)
	-- self.scale = vector(scale.x * scaleAdjust.x, scale.y * scaleAdjust.y, scale.z * scaleAdjust.z)
end



-- Create pattern mesh/object to draw the new canvas texture with

-- patternMesh = createMeshFbx("meshes/pattern_1.fbx")
patternMesh = createMeshFbx("meshes/file_digged.fbx")
patternObject = createObjectShape(patternMesh, vector(0, 0), sceneGroup)
patternObject.texture = drawSetCanvas.canvas

patternMeshClip = createMeshFbx("meshes/file_digged_clip.fbx")
patternObjectClip = createObjectShape(patternMeshClip, vector(0, 0), sceneGroup)
patternObjectClip.texture = drawSetCanvas2.canvas


-- Create text instructions

textLine1 = "Chuang Xie 2019\n"
textLine2 = "The Birth of the Universe\n"
textLine3 = ""

objectText = createObjectText(textLine1 .. textLine2 .. textLine3, "center", "center", vector(40, 20), vector(0, -35), sceneGroup)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2



-- Pos Y Slider
local camera = createObjectCamera(100, vector(0, 0, 50))
local menu = createObjectMenu(camera)	

local buttonSlider1 = createObjectButtonSlider(vector(0, 35), 16, -100, 100.0, menu)
local buttonSlider2 = createObjectButtonSlider(vector(20, 35), 16, -100, 100.0, menu)
local buttonSlider3 = createObjectButtonSlider(vector(40, 35), 16, 0.0, 6, menu)


function buttonSlider1:updateValue(value) 
	offset.x = value 
	-- print("posX " .. value)
end

function buttonSlider2:updateValue(value) 
	offset.y = value 
	-- print("posY " .. value)
end

function buttonSlider3:updateValue(value) 
	scaleAdjust = vector(value, value, value)
	-- print("scale " .. value)
end

menu:addButton(buttonSlider1)
menu:addButton(buttonSlider2)
menu:addButton(buttonSlider3)

function updateSliders()
	buttonSlider1:setValue(offset.x)
	buttonSlider2:setValue(offset.y)
	buttonSlider3:setValue(scaleAdjust.x)
end



posY = 35

buttonColorLabel = menu:addButton(createObjectButton("Stage", vector(5, 2), vector(-42, posY) ))
buttonColorPrev = menu:addButton(createObjectButton("<", vector(3, 2), vector(-34, posY)))
buttonColorNext = menu:addButton(createObjectButton(">", vector(3, 2), vector(-28, posY)))


buttonAuto = menu:addButton(createObjectButton("Auto", vector(3, 2), vector(-22, posY )))
buttonManual = menu:addButton(createObjectButton("Manual", vector(3, 2), vector(-16, posY)))

buttonColorLabel.textChild.textSize = 1.5
buttonColorPrev.textChild.textSize = 1.5
buttonColorNext.textChild.textSize = 1.5
buttonAuto.textChild.textSize = 1.5
buttonManual.textChild.textSize = 1.5

buttonColorLabel.color = color(0.3, 0.3, 0.3, 1)
buttonAuto.color = color(0.3, 0.3, 0.3, 1)
buttonManual.color = color(0.3, 0.3, 0.3, 1)

phaseIndex = 1
-- lua array start with index 1
phaseArray = {
	vector(-82.5, 38.75, 1), 	-- null
	vector(-81.25, 37.5,1),  	-- dot
	vector(-78.75, 35, 1), 		-- big dot
	vector(-71.25, 35, 1),		-- two dot
	vector(-71.25, 23.75, 1),
	vector(-71.25, 18.75, 1),
	vector(-56.25, 18.75, 1),
	vector(-56.25, 2.5, 1),
	vector(0, 2.5, 1),
	vector(0, -7.5, 1),
	vector(0, -7.5, 1.3),
	vector(0, -7.5, 2.3),
	vector(-8, 23.75, 6),

	nil
}

timeTable = {
	vector(0, 10),
	vector(13, 13.5),			-- show dot
	vector(18.5, 24.4),			-- show bigger dot
	vector(35.8, 38.6), 		-- show two dot
	vector(42, 47), 			-- show H
	vector(59, 60), 			-- show H Sep
	vector(64.8, 68),			-- show 4 leg
	vector(70.5, 72),			-- show 2 bug
	vector(76, 78),				-- show 4 love 2d
	vector(79, 80),				-- x move
	vector(81.4, 83),				-- scale big
	vector(83.7, 89),				-- scale very big
	vector(89, 100)				-- scale very big

}

function updateStateUsingTime()

	if time < timeTable[2].x then
		updateState(phaseArray[1])
		return
	end

	

	for i = 2, #timeTable do
		local prevIt = timeTable[i - 1]
		local prevEndTime = prevIt.y	

		local it = timeTable[i]
		local startTime = it.x
		local endTime = it.y

		if time >= prevEndTime and time < startTime then
			updateState(phaseArray[i - 1])
			break
		end

		if time >= startTime and time <= endTime then
			local progress = (time - startTime) / (endTime - startTime)
			local newX = phaseArray[i - 1].x + (phaseArray[i].x - phaseArray[i - 1].x) * progress
			local newY = phaseArray[i - 1].y + (phaseArray[i].y - phaseArray[i - 1].y) * progress
			local newZ = phaseArray[i - 1].z + (phaseArray[i].z - phaseArray[i - 1].z) * progress

			updateState(vector(newX, newY, newZ))
			break
		end
	end
end

function updateState(iter)
	offset = vector(iter.x, iter.y)
	scaleAdjust = vector(iter.z, iter.z, iter.z)
	updateSliders()
end

function updatePhaseData()
	local iter = phaseArray[phaseIndex]
	updateState(iter)
end

updatePhaseData()


function buttonColorNext:action()
	if phaseArray[phaseIndex + 1] ~= nil then
		phaseIndex = phaseIndex + 1
	end
	
	updatePhaseData()

end

function buttonColorPrev:action()
	phaseIndex = phaseIndex - 1
	if phaseIndex < 1 then
		phaseIndex = 1
	end
	updatePhaseData()

end

function buttonAuto:action()
	manualMode = false
end

function buttonManual:action()
	manualMode = true
end


function updateCamScale()
	globalCameraMain:setViewSize(100 / scaleAdjust.x)
end

function rootObject:update(dt)
	time = time + dt

	if manualMode then

	else
	
		updateStateUsingTime()
	end
	
	updateCamScale()

	-- print(time)
	textLine3 = offset.x  .. "     " .. offset.y .. "    " .. scaleAdjust.x
	objectText.text = textLine1 .. textLine2 ..textLine3

	-- Control camera position with up/down/left/right
	local distance = 0.005
	if love.keyboard.isDown("up") then clipOffset.y = clipOffset.y + 50 * dt end

	-- print(globalCameraMain.viewSize.x)

end

src1 = love.audio.newSource(globalScenePath .."music/2001.mp3", "static") 
src1:setVolume(0.9) -- 90% of ordinary volume
src1:play()