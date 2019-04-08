require("lib/globals")

cacheSize = 15
sliderMode = false
time = 0



List = {}
function List.new ()
	return {first = 0, last = -1}
end

function List.pushleft (list, value)
	local first = list.first - 1
	list.first = first
	list[first] = value
end

function List.pushright (list, value)
	local last = list.last + 1
	list.last = last
	list[last] = value
end

function List.popleft (list)
	local first = list.first
	if first > list.last then error("list is empty") end
	local value = list[first]
	list[first] = nil        -- to allow garbage collection
	list.first = first + 1
	return value
end

function List.popright (list)
	local last = list.last
	if list.first > last then error("list is empty") end
	local value = list[last]
	list[last] = nil         -- to allow garbage collection
	list.last = last - 1
	return value
end


cache = List.new()

for i = 1 ,cacheSize do
	List.pushright(cache, {0, 0, 0, 0, 0})
end



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



-- Create the row canvas
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


-- Create the 1 canvas
drawSetCanvas3 = createObject(vector(0, 0), rootObject)
drawSetCanvas3.canvas = love.graphics.newCanvas(512, 512)
drawSetCanvas3.canvas:setWrap("clamp", "clamp") -- Options include: "clamp", "repeat", "mirroredrepeat" 
function drawSetCanvas3:draw(camera)
	love.graphics.setCanvas({ self.canvas, depth = true })
	love.graphics.clear(0.0, 0.0, 0.0, 1)
end

textureGroup3 = createObject(vector(0, 0), rootObject)

drawResetCanvas3= createObject(vector(0, 0), rootObject)
function drawResetCanvas3:draw(camera)	
	love.graphics.setCanvas(nil)
end



-- Create scene-group and camera (for drawing the pattern using the canvas texture)

sceneCamera = createObjectCamera(100, vector(0, 0), rootObject)

sceneGroup = createObject(vector(0, 0), rootObject)
sceneGroup.camera = sceneCamera -- Comment out this line to restore default camera to scene group

-- Create an object to be drawn in texture-group (drawn to the canvas texture)

-- cubeMesh = createMeshFbx("meshes/color_cube.fbx")
-- cubeObject = createObjectShape(cubeMesh, vector(0, 0, 10), textureGroup)

pos = vector(0, -25)
offset = vector(0, 0)

scale = vector(35, 28, 1) 
-- now the scaleAdjust only adjust the main camera, doesn't effect the object's own scale any more
scaleAdjust = vector(1.0, 1.0, 1.0) 

cubeMesh = createMeshFbx("meshes/file_haha.fbx")

cubeMeshShake = createMeshFbx("meshes/file_haha_shake.fbx")
cubeMeshLeft = createMeshFbx("meshes/file_haha_left.fbx")
cubeMeshRight = createMeshFbx("meshes/file_haha_right.fbx")
cubeMeshCrouch = createMeshFbx("meshes/file_haha_crouch.fbx")
cubeMeshJumpHigh = createMeshFbx("meshes/file_haha_jump_high.fbx")


cubeMeshArray = {cubeMeshShake, cubeMeshLeft, cubeMeshRight, cubeMeshCrouch, cubeMeshJumpHigh}
lableArray = {"Shake", "Left", "Right", "Crouch", "Jump High"}
lerpArray = {0, 0, 0, 0, 0}
lerpSpeedArray = {1, 1, 1, 1, 1}
baseSpeed = 6 


cubeObject = createObjectShape(cubeMesh, vector(pos.x, pos.y, 10), textureGroup)
morpher = createMorpher(cubeMesh)
 
cubeObject.scale = scale
function cubeObject:update(dt)
	self.position = vector(pos.x + offset.x, pos.y + offset.y, 10)
	self.scale = vector(scale.x * scaleAdjust.x, scale.y * scaleAdjust.y, scale.z * scaleAdjust.z)
end

clipOffset = vector(0, 0);

cubeMeshRow = createMeshFbx("meshes/file_haha.fbx")
morpher2 = createMorpher(cubeMeshRow)
cubeObjectRow = createObjectShape(cubeMeshRow, vector(pos.x, pos.y, 10), textureGroup2)
cubeObjectRow.scale = scale
function cubeObjectRow:update(dt)
	-- self.position = vector(pos.x + offset.x, pos.y + offset.y, 10)
	self.scale = vector(scale.x * scaleAdjust.x, scale.y * scaleAdjust.y, scale.z * scaleAdjust.z)
end

cubeMeshClip = createMeshFbx("meshes/file_haha.fbx")
morpherClip = createMorpher(cubeMeshClip)
cubeObjectClip = createObjectShape(cubeMeshClip, vector(pos.x, pos.y, 10), textureGroup3)
cubeObjectClip.scale = scale


function cubeObjectClip:update(dt)
	-- self.position = vector(pos.x + offset.x, pos.y + offset.y, 10)
	self.scale = vector(scale.x * scaleAdjust.x, scale.y * scaleAdjust.y, scale.z * scaleAdjust.z)
end



-- Create pattern mesh/object to draw the new canvas texture with

-- patternMesh = createMeshFbx("meshes/pattern_1.fbx")
canvasObjectOffset = -6

patternMesh = createMeshFbx("meshes/file_digged_tilted_wide_digged.fbx")
patternObject = createObjectShape(patternMesh, vector(0, canvasObjectOffset), sceneGroup)
patternObject.texture = drawSetCanvas.canvas

patternMesh2 = createMeshFbx("meshes/file_digged_tilted_wide_row.fbx")
patternObject2 = createObjectShape(patternMesh2, vector(0, canvasObjectOffset), sceneGroup)
patternObject2.texture = drawSetCanvas2.canvas

patternMeshClip = createMeshFbx("meshes/file_digged_tilted_wide_clipped.fbx")
patternObjectClip = createObjectShape(patternMeshClip, vector(0, canvasObjectOffset), sceneGroup)
patternObjectClip.texture = drawSetCanvas3.canvas


-- Create text instructions

textLine1 = "THE PATTERN IS DEFINED BY THE MESH AND ITS UV CONFIGURATION (PRESS 4 TO SEE THE WIREFRAME)\n"
textLine2 = "NAVIGATE THE SCENE WITH DEFAULT CONTROLS TO MANIPULATE THE PATTERN\n"
textLine3 = ""

objectText = createObjectText(textLine1 .. textLine2 .. textLine3, "center", "center", vector(40, 20), vector(0, -35), sceneGroup)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2



-- Pos Y Slider
local camera = createObjectCamera(100, vector(0, 0, 50))
local menu = createObjectMenu(camera)	

row1SliderLeft = -10
local buttonSlider1 = createObjectButtonSlider(vector(row1SliderLeft + 0, 35), 16, -100, 100.0, menu)
local buttonSlider2 = createObjectButtonSlider(vector(row1SliderLeft + 20, 35), 16, -100, 100.0, menu)
local buttonSlider3 = createObjectButtonSlider(vector(row1SliderLeft + 40, 35), 16, 0.0, 2, menu)

lerpSliders = {}
for i = 1, 5 do
	local iterPosX = 0 + 18 * (i - 3)
	lerpSliders[i] = createObjectButtonSlider(vector(iterPosX, 28), 15, 0, 1, menu)
	lerpSliders[i]:setValue(0)
	menu:addButton(lerpSliders[i])
	local ti = createObjectText(lableArray[i], "center", "center", vector(40, 20), vector(iterPosX, 24), menu)
	ti.color:set(0.5, 0.5, 0.5, 1)
	ti.lineHeight = 1.3
	ti.textSize = 1.5
	
end

lerpSliders1 = lerpSliders[1]
lerpSliders2 = lerpSliders[2]
lerpSliders3 = lerpSliders[3]
lerpSliders4 = lerpSliders[4]
lerpSliders5 = lerpSliders[5]
function lerpSliders1:updateValue(value) 
	lerpSliderUpdateValue(value, 1)
end
function lerpSliders2:updateValue(value) 
	lerpSliderUpdateValue(value, 2)
end
function lerpSliders3:updateValue(value) 
	lerpSliderUpdateValue(value, 3)
end
function lerpSliders4:updateValue(value) 
	lerpSliderUpdateValue(value, 4)
end
function lerpSliders5:updateValue(value) 
	lerpSliderUpdateValue(value, 5)
end

function updateSlidersUsingLerpArray()
	for i = 1, #lerpSliders do
		lerpSliders[i]:setValue(lerpArray[i])
	end
end

function lerpSliderUpdateValue(value, i)
	lerpArray[i] = value
end



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



buttonAuto = menu:addButton(createObjectButton("KeyMode", vector(5, 2), vector(-42, posY)))
buttonManual = menu:addButton(createObjectButton("SliderMode", vector(5, 2), vector(-31, posY)))

buttonAuto.textChild.textSize = 1.5
buttonManual.textChild.textSize = 1.5

buttonAuto.color = color(0.3, 0.3, 0.3, 1)
buttonManual.color = color(0.3, 0.3, 0.3, 1)


function buttonAuto:action()
	sliderMode = false
end

function buttonManual:action()
	sliderMode = true
end



function updateCamScale()
	globalCameraMain:setViewSize(100 / 1.1)
end

lastPressed = -1

function blendPressed(dt, i)
	lastPressed = i
	lerpArray[i] = lerpArray[i] + baseSpeed * lerpSpeedArray[i] * dt
	if lerpArray[i] > 1 then
		lerpArray[i] = 1
	end
end

function shake(dt)
	blendPressed(dt, 1)	
end

function left(dt)
	blendPressed(dt, 2)
end

function right(dt)
	blendPressed(dt, 3)
end

function crouch(dt)
	blendPressed(dt, 4)
end

function jumpHigh(dt)
	blendPressed(dt, 5)
end

function updateMorpherByLerpArray(dt)
	morpher:reset()
	morpher2:reset()
	morpherClip:reset()
	for i = 1, #cubeMeshArray do

		if sliderMode == false then	
			if i ~= lastPressed then
				lerpArray[i] = lerpArray[i] - baseSpeed * lerpSpeedArray[i] * dt
				if lerpArray[i] < 0 then lerpArray[i] = 0 end		
			end
			
			updateSlidersUsingLerpArray()
		end
		
		morpher:blendXY(cubeMeshArray[i], lerpArray[i])	
		morpher2:blendXY(cubeMeshArray[i], lerpArray[i])	
	end	

	
	
	local delayedData = List.popleft(cache)
	List.pushright(cache, {lerpArray[1], lerpArray[2], lerpArray[3], lerpArray[4], lerpArray[5]})

	for i = 1, 5 do
		morpherClip:blendXY(cubeMeshArray[i], delayedData[i])
	end
	
	


	morpher:updateMesh()
	morpher2:updateMesh()
	morpherClip:updateMesh()
end



function resetMorpher()
	morpher:reset()
	morpher:updateMesh()
end


timeOut = 20.4
timeIn = 42.8

outDt = 2
inDt = 2

inInAnimation = false
inOutAnimation = faslse

outY = 70
inY = 0

outSpeed = (outY - inY ) / outDt
inSpeed = (inY - outY) / inDt

timeOut = 2
timeIn = 8
function checkIfRemoveOthers(dt)
	
	if time > timeOut and time < timeIn then
		inInAnimation = false
		inOutAnimation = true
	end

	if time >= timeIn then
		inInAnimation = true
		inOutAnimation = false
	end

	if inOutAnimation then
		offset.y = offset.y + outSpeed * dt
		if offset.y > outY then offset.y = outY end
	end

	if inInAnimation then
		offset.y = offset.y + inSpeed * dt
		if offset.y < inY then offset.y = inY end
	end
end


bpm = 128
secondPerBeat = 60.0 / 128.0
beginScaleShakeTime = timeIn
function updateScaleShake(dt)
	if time < beginScaleShakeTime then return end

	local rem = time % secondPerBeat

	local diffToMiddle = rem - secondPerBeat / 2
	if diffToMiddle < 0 then diffToMiddle = -diffToMiddle end
	
	local s = diffToMiddle / (secondPerBeat / 2) * 0.1 + 1
	scaleAdjust.x = s
	scaleAdjust.y = s
	scaleAdjust.z = s

	updateSliders()
end

function rootObject:update(dt)
	time = time + dt

	checkIfRemoveOthers(dt)
	updateCamScale()

	updateScaleShake(dt)


	-- print(time)
	textLine3 = offset.x  .. "     " .. offset.y .. "    " .. scaleAdjust.x
	objectText.text = textLine1 .. textLine2 ..textLine3

	-- Control camera position with up/down/left/right
	local distance = 0.005

	if sliderMode then
		lastPressed = -1
	elseif love.keyboard.isDown("left") then left(dt) 	
	elseif love.keyboard.isDown("right") then right(dt) 
	elseif love.keyboard.isDown("down") then crouch(dt) 
	elseif love.keyboard.isDown("up") then jumpHigh(dt) 
	elseif love.keyboard.isDown("space") then shake(dt) 
	else lastPressed = -1
	end
	
	updateMorpherByLerpArray(dt)
	-- print("  " .. lerpArray[1])
	lerpSliders1:setValue(lerpArray[1])
	-- print(globalCameraMain.viewSize.x)

end

-- function love.keyreleased(key)
-- 	if key == "escape" then
-- 	   love.event.quit()
-- 	end
--  end

src1 = love.audio.newSource(globalScenePath .."music/Duck.mp3", "static") 
src1:setVolume(0.9) -- 90% of ordinary volume
src1:play()