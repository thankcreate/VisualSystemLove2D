require('lib/particles')
require('lib/object')

-- Create a particle object that draws a CUSTOM particle system

function createObjectEmitter(emitter, vecPosition, objParent) --function createObjectCustomParticles(particles, vecPosition, objParent)

	local obj = createObject(vecPosition, objParent) -- The object that will be returned
	
	obj.emitter = emitter
	obj.shader = shaderParticle
	
	function obj:updateWorldMatrix()
	
		-- Start with rotation matrix
		
		self.worldMatrix:copy(self.rotationMatrix)
		
		-- Scale "right" vector of matrix with self.scale.x
		
		self.worldMatrix[1][1] = self.worldMatrix[1][1] * self.scale.x
		self.worldMatrix[1][2] = self.worldMatrix[1][2] * self.scale.x
		self.worldMatrix[1][3] = self.worldMatrix[1][3] * self.scale.x
		
		-- Scale "up" vector of matrix with self.scale.y
		
		self.worldMatrix[2][1] = self.worldMatrix[2][1] * self.scale.y
		self.worldMatrix[2][2] = self.worldMatrix[2][2] * self.scale.y
		self.worldMatrix[2][3] = self.worldMatrix[2][3] * self.scale.y
		
		-- Scale "look" vector of matrix with self.scale.y
		
		self.worldMatrix[3][1] = self.worldMatrix[3][1] * self.scale.z
		self.worldMatrix[3][2] = self.worldMatrix[3][2] * self.scale.z
		self.worldMatrix[3][3] = self.worldMatrix[3][3] * self.scale.z
		
		-- Assign "position" vector of matrix with self.position values
	
		self.worldMatrix[4][1] = self.position.x
		self.worldMatrix[4][2] = self.position.y
		self.worldMatrix[4][3] = self.position.z
		self.worldMatrix[4][4] = 1
		
		if self.parent then
		
			-- Combine with the parent object's world transformation
		
			self.worldMatrix:multiplyAB(self.parent.worldMatrix)
		
		end
	
		if self.emitter then 
		
			local lengthRight = (self.worldMatrix[1][1] * self.worldMatrix[1][1]) + (self.worldMatrix[1][2] * self.worldMatrix[1][2]) + (self.worldMatrix[1][3] * self.worldMatrix[1][3])
			local lengthUp = (self.worldMatrix[1][1] * self.worldMatrix[1][1]) + (self.worldMatrix[1][2] * self.worldMatrix[1][2]) + (self.worldMatrix[1][3] * self.worldMatrix[1][3])
		
			-- Now that the world matrix has been updated, pass its xy pos to Love's particle emitter position
	
			self.emitter.scale.x = lengthRight
			self.emitter.scale.y = lengthUp
			self.emitter.scale.z = 1
			self.emitter.position.x = self.worldMatrix[4][1]
			self.emitter.position.y = self.worldMatrix[4][2]
		
			self.emitter:update(0.016667)
			
		end
	
	end

	function obj:draw(camera) -- Draw the object (using camera data)
	
		if self.emitter then
			
			-- Start with a copy of the view matrix because the particle system's root shouldn't move (emitter pos set in update function)
			
			matTemp:copy(camera.viewMatrix)
			matTemp:multiplyAB(camera.projMatrix)
			
			-- Send this combination of world, view and projection matrices to the shader

			love.graphics.setShader(self.shader.source)
			love.graphics.setBlendMode(self.blendMode, self.alphaMode)
		
			uniformWorldViewProj = matTemp
			uniformColorBlend = self.color
		
			self.shader:updateUniforms()
		
			self.emitter:drawParticles()
			
		end
	
	end
	
	return obj
	
end

-- Create a particle object that draws a LOVE2D particle system
--[[
function createObjectParticles(particles, vecPosition, objParent)

	local obj = createObject(vecPosition, objParent) -- The object that will be returned
	
	obj.particles = particles
	obj.shader = shaderParticle
	
	function obj:update(deltaTime)
	
		if self.particles then 
			
			self:updateWorldMatrix()
			
			-- Now that the world matrix has been updated, pass its xy pos to Love's particle emitter position
		
			local x = self.parent.worldMatrix[4][1]
			local y = self.parent.worldMatrix[4][2]
		
			self.particles:moveTo(x, y)
			self.particles:update(deltaTime)
			
		end
	
	end

	function obj:draw(camera) -- Draw the object (using camera data)
	
		if self.particles then
			
			 -- Start with a copy of the view matrix because the particle system's root shouldn't move (emitter pos is set in update function)
			 
			matTemp:copy(camera.viewMatrix)
			matTemp:multiplyAB(camera.projMatrix)
			
			-- Send this combination of world, view and projection matrices to the shader

			love.graphics.setShader(self.shader.source)
			love.graphics.setBlendMode(self.blendMode, self.alphaMode)
		
			uniformWorldViewProj = matTemp
			uniformColorBlend = self.color
		
			self.shader:updateUniforms()
			
			-- Use love's draw call without any of the pos/angle data because it's all been sent to the shader!
		
			love.graphics.draw(self.particles)
			
		end
	
	end
	
	return obj
	
end
]]--