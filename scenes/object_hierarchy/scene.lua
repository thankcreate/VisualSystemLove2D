require('lib/color')
require('lib/path')
require('lib/object_shape')
 
-- Setup scene

local rootObject = createObject(vector(0, -15), nil)

local mesh1 = createMeshRectangle(-0.5, 0.5, 0, 10, WHITE, WHITE, WHITE, WHITE)

local object1 = createObjectShape(mesh1, vector(0, 0), rootObject) -- Parented to root object
local object2 = createObjectShape(mesh1, vector(0, 10), object1)   -- Parented to object1
local object3 = createObjectShape(mesh1, vector(0, 10), object2)   -- Parented to object2

object1.color:set(1, 0, 0, 1)
object2.color:set(0, 1, 0, 1)
object3.color:set(0, 0, 1, 1)

function object1:update(dt) -- Over-ride this object's update function (called every frame)

	if love.keyboard.isDown("up") then
	
		self.position.y = self.position.y + (5.0 * dt)
		
	elseif love.keyboard.isDown("down") then
	
		self.position.y = self.position.y - (5.0 * dt)
	
	end

end

function object2:update(dt) -- Over-ride this object's update function

	if love.keyboard.isDown("left") then
	
		self:rotateZ(1.5 * -dt)
		
	elseif love.keyboard.isDown("right") then
	
		self:rotateZ(1.5 * dt)
	
	end

end

function object3:update(dt) -- Over-ride this object's update function

	if love.keyboard.isDown("left") then
	
		self:rotateZ(3.0 * -dt)
		
	elseif love.keyboard.isDown("right") then
	
		self:rotateZ(3.0 * dt)
	
	end

end

objectText = createObjectText("PRESS LEFT/RIGHT TO ROTATE ARMATURE\nPRESS UP/DOWN TO MOVE ROOT", "center", "center", vector(20, 5), vector(0, -12), rootObject)

objectText.color:set(0.5, 0.5, 0.5, 1)
objectText.lineHeight = 1.3
objectText.textSize = 1.2

