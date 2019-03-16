require('lib/object')

object_text = {}

object_text.font = love.graphics.newImageFont("lib/assets/images/futura.png", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{};':" .. '",.<>?/~ \\', 0)

-- Create distance shader (text will be rendered with distance field images)

object_text.shader = createShader("lib/assets/shaders/v_text.vert", "lib/assets/shaders/f_text.frag")
object_text.uniformFocus = 0

function object_text.shader:updateUniforms()

	local s = self.source
	local m = flipMatrix(uniformWorldViewProj) -- Matrix sent to shader needs to be switched from column-major to row-major

	if s:hasUniform("worldViewProj") then s:send("worldViewProj", m) end
	if s:hasUniform("focus") then s:send("focus", object_text.uniformFocus) end
	if s:hasUniform("colorBlend") then s:send("colorBlend", { uniformColorBlend.r, uniformColorBlend.g, uniformColorBlend.b, uniformColorBlend.a }) end
	
end

-- Create a basic button 

function createObjectText(text, justifyX, justifyY, vecExtents, vecPosition, objParent)

	local obj = createObject(vecPosition, objParent) -- The object that will be returned
	
	obj.type = "text"
	obj.extents = vectorCopy(vecExtents)
	obj.color = color(1, 1, 1, 1)
	obj.shader = object_text.shader
	obj.font = object_text.font
	obj.text = text
	obj.textSize = 1.0
	obj.textFixed = false
	obj.lineHeight = 1.0
	obj.justifyX = justifyX
	obj.justifyY = justifyY
	obj.blendMode = "alpha"
	obj.alphaMode = "premultiplied"
	
	function obj:draw(camera)
		
		-- Draw text
		
		if self.text and self.font and self.shader then 
		
			self:drawText(camera, self.text, self.font, self.shader)
			
		end
		
	end
	
	
	function obj:drawText(camera, text, font, shader)
	
		-- Start with blank matrix and update xy position values
		
		matTemp:copy(self.worldMatrix)
		
		matTemp[2][1] = -matTemp[2][1] -- Flippity do da
		matTemp[2][2] = -matTemp[2][2] -- Flippity do da
		
		local scaleWorld = math.sqrt((matTemp[1][1] * matTemp[1][1]) + (matTemp[1][2] * matTemp[1][2]))
	
		-- Multiply the world matrix copy with the camera's view matrix and projection matrices
	
		matTemp:multiplyAB(camera.viewMatrix)
		matTemp:multiplyAB(camera.projMatrix)
		
		-- Set and update shader, then draw text
		
		love.graphics.setShader(shader.source)
		
		if self.textFixed then
		
			object_text.uniformFocus = (scaleWorld / self.textSize) * 0.07
			
		else
		
			object_text.uniformFocus = (camera.viewSize.x / love.graphics.getWidth() / scaleWorld / self.textSize) * 4.0
		
		end
	
		uniformWorldViewProj = matTemp
		uniformColorBlend = self.color
	
		shader:updateUniforms()
		
		love.graphics.setBlendMode(self.blendMode, self.alphaMode)
		
		-- Configure Love2D text drawing settings (it will batch all of the character polygons for us)
		
		font:setLineHeight(self.lineHeight)
		
		local height = font:getHeight(text)
		
		local textScale = 1.0
		
		if self.textFixed then --This will draw font at its original bitmap size
		
			textScale = (camera.viewSize.x / love.graphics.getWidth()) * self.textSize 
		
		else
		
			textScale = self.textSize / height
			
		end
		
		local textX = (self.extents.x * 2) / textScale
		local textY = 0
		
		wrapWidth, wrapText = font:getWrap(text, textX)
		
		if self.justifyY == "top" then
		
			textY = -self.extents.y
		
		elseif self.justifyY == "bottom" then
		
			local totalY = (height * textScale) + ((#wrapText - 1) * self.lineHeight * height * textScale)
			
			textY = self.extents.y - totalY
		
		else -- "center"
		
			local totalY = (height * textScale) + ((#wrapText - 1) * self.lineHeight * height * textScale)
			
			textY = totalY * -0.5
		
		end
 		
		love.graphics.setFont(font)
		love.graphics.printf(text, -self.extents.x, textY, textX, self.justifyX, 0, textScale, textScale)
	
	end
	
	return obj

end
