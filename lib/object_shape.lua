require('lib/globals')
require('lib/shape')
require('lib/object')

-- Create a shape object that draws a mesh

function createObjectShape(meshShape, vecPosition, objParent)

	local obj = createObject(vecPosition, objParent) -- The object that will be returned
	
	obj.mesh = meshShape
	obj.shader = shaderMesh
	obj.texture = nil
	obj.extents = vector(1, 1, 1) -- Take from mesh?
	
	function obj:draw(camera) -- Draw the object (using camera data)
	
		if self.mesh and self.shader then
		
			self.mesh:setTexture(self.texture) -- This is a love2D "mesh" function, but under the hood it's setting a shader uniform
			
			love.graphics.setBlendMode(self.blendMode, self.alphaMode)
		
			self:drawShape(self.mesh, self.shader, self.color, self.alpha, camera)
			
		end
	
	end
	
	function obj:drawShape(mesh, shader, color, alpha, camera)
	
		-- Start with a copy of this object's world matrix (because we're manipulating it!)
		 
		matTemp:copy(self.worldMatrix)
	
		-- Multiply the world matrix copy with the camera's view and projection matrices
	
		matTemp:multiplyAB(camera.viewMatrix)
		matTemp:multiplyAB(camera.projMatrix)
		
		-- Send this combination of world, view and projection matrices to the shader

		love.graphics.setShader(shader.source)
		
		uniformWorldObject = self.worldMatrix
		uniformWorldCamera = camera.worldMatrix
		uniformWorldViewProj = matTemp
		uniformColorBlend = color
		uniformAlpha = alpha
	
		shader:updateUniforms()
		
		-- Use love's draw call without any of the pos/angle data because it's all been sent to the shader!
		
		love.graphics.draw(mesh)
		
	end
	
	function obj:loadTexture(path, generateMipmaps) -- Load and set an image texture
	
		if generateMipmaps ~= true and generateMipmaps ~= false then generateMipmaps = false end
	
		self.texture = love.graphics.newImage(globalScenePath .. path, { mipmaps = generateMipmaps })
	
	end

	
	return obj
	
end
