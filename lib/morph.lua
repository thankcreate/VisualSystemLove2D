-- Create tool to manage shape/color blending

function createMorpher(shapeBase)

	obj = {}
	
	obj.baseMesh = shapeBase
	obj.baseMin = vector(0, 0, 0)
	obj.baseMax = vector(0, 0, 0)
	obj.baseVertexCount = shapeBase:getVertexCount()
	obj.originalVertices = {}
	obj.modifiedVertices = {}
	
	for i = 1, obj.baseVertexCount do
	
		-- Keep a copy of base mesh vertex data so that we can reference it...
		-- Also keep copy for manipulation and for sending deformations to self.baseMesh
		
		local x, y, z, u, v, r, g, b, a = shapeBase:getVertex(i)
		
		if i == 1 then
		
			obj.baseMin:set(x, y, z)
			obj.baseMax:set(x, y, z)
		
		else
			
			if x > obj.baseMax.x then obj.baseMax.x = x elseif x < obj.baseMin.x then obj.baseMin.x = x end
			
			if y > obj.baseMax.y then obj.baseMax.y = y elseif y < obj.baseMin.y then obj.baseMin.y = y end
			
			if z > obj.baseMax.z then obj.baseMax.z = z elseif z < obj.baseMin.z then obj.baseMin.z = z end
			
		end
			
		obj.originalVertices[i] = { x = x, y = y, z = z, r = r, u = u, v = v, g = g, b = b, a = a }
		obj.modifiedVertices[i] = { x = x, y = y, z = z, r = r, u = u, v = v, g = g, b = b, a = a }
		
	end
	
	function obj:reset() -- Reset deformations back to original state
	
		for i = 1, self.baseVertexCount do
		
			local vO = self.originalVertices[i]
			
			self.modifiedVertices[i].x = vO.x
			self.modifiedVertices[i].y = vO.y
			self.modifiedVertices[i].z = vO.z
			self.modifiedVertices[i].u = vO.u
			self.modifiedVertices[i].v = vO.v
			self.modifiedVertices[i].r = vO.r
			self.modifiedVertices[i].g = vO.g
			self.modifiedVertices[i].b = vO.b
			self.modifiedVertices[i].a = vO.a
			
		end
		
	end
	
	function obj:updateMesh()
	
		local t = self.modifiedVertices
	
		for i = 1, self.baseVertexCount do
			
			local v = t[i]
		
			self.baseMesh:setVertex(i, v.x, v.y, v.z, v.u, v.v, v.r, v.g, v.b, v.a)
			
		end
	
	end
	
	function obj:blendXY(shape, weight) -- Add difference in shape by a weight/strength
	
		if shape:getVertexCount() == self.baseVertexCount then
		
			for i = 1, self.baseVertexCount do
			
				local x, y, z, u, v, r, g, b, a = shape:getVertex(i)
			
				local vO = self.originalVertices[i]
				local vM = self.modifiedVertices[i]
				
				vM.x = vM.x + ((x - vO.x) * weight)
				vM.y = vM.y + ((y - vO.y) * weight)
				
			end
		
		end
	
	end
	
	function obj:blendXYZ(shape, weight) -- Add difference in shape by a weight/strength
	
		if shape:getVertexCount() == self.baseVertexCount then
		
			for i = 1, self.baseVertexCount do
			
				local x, y, z, u, v, r, g, b, a = shape:getVertex(i)
			
				local vO = self.originalVertices[i]
				local vM = self.modifiedVertices[i]
				
				vM.x = vM.x + ((x - vO.x) * weight)
				vM.y = vM.y + ((y - vO.y) * weight)
				vM.z = vM.z + ((z - vO.z) * weight)
				
			end
		
		end
	
	end
	
	function obj:blendRGB(shape, color, weight) -- Blend a color by value of R channel combined with an overall weight/strength 
	
		if shape:getVertexCount() == self.baseVertexCount then
		
			if weight > 1 then weight = 1 elseif weight < 0 then weight = 0 end
		
			for i = 1, self.baseVertexCount do
			
				local x, y, z, u, v, r, g, b, a = shape:getVertex(i)
			
				local vM = self.modifiedVertices[i]
			
				local weight = weight * r
				local weightInv = 1 - weight
				
				vM.r = (vM.r * weightInv) + (color.r * weight)
				vM.g = (vM.g * weightInv) + (color.g * weight)
				vM.b = (vM.b * weightInv) + (color.b * weight)
				
			end
		
		end
	
	end
	
	function obj:blendRGBA(shape, color, weight) -- Blend a color by value of R channel combined with an overall weight/strength 
	
		if shape:getVertexCount() == self.baseVertexCount then
		
			if weight > 1 then weight = 1 elseif weight < 0 then weight = 0 end
		
			for i = 1, self.baseVertexCount do
			
				local x, y, z, u, v, r, g, b, a = shape:getVertex(i)
			
				local vM = self.modifiedVertices[i]
			
				local weight = weight * r
				local weightInv = 1 - weight
				
				vM.r = (vM.r * weightInv) + (color.r * weight)
				vM.g = (vM.g * weightInv) + (color.g * weight)
				vM.b = (vM.b * weightInv) + (color.b * weight)
				vM.a = (vM.a * weightInv) + (color.a * weight)
				
			end
		
		end
	
	end
	
	function obj:fillRGB(color, weight)
		
		if weight > 1 then weight = 1 elseif weight < 0 then weight = 0 end
	
		for i = 1, self.baseVertexCount do
		
			local vM = self.modifiedVertices[i]
		
			local weightInv = 1 - weight
			
			vM.r = (vM.r * weightInv) + (color.r * weight)
			vM.g = (vM.g * weightInv) + (color.g * weight)
			vM.b = (vM.b * weightInv) + (color.b * weight)
			
		end
	
	end
	
	function obj:fillRGBA(color, weight)
		
		if weight > 1 then weight = 1 elseif weight < 0 then weight = 0 end
	
		for i = 1, self.baseVertexCount do
		
			local vM = self.modifiedVertices[i]
		
			local weightInv = 1 - weight
			
			vM.r = (vM.r * weightInv) + (color.r * weight)
			vM.g = (vM.g * weightInv) + (color.g * weight)
			vM.b = (vM.b * weightInv) + (color.b * weight)
			vM.a = (vM.a * weightInv) + (color.a * weight)
			
		end
	
	end
	
	function obj:maskRGB(index, color, weight)
		
		if weight > 1 then weight = 1 elseif weight < 0 then weight = 0 end
		
		if     index == 1 then index = "r"
		elseif index == 2 then index = "g"
		elseif index == 3 then index = "b"
		else    			   index = "a" end
	
		for i = 1, self.baseVertexCount do
		
			local vM = self.modifiedVertices[i]
		
			local weight = weight * self.originalVertices[i][index]
			local weightInv = 1 - weight
			
			vM.r = (vM.r * weightInv) + (color.r * weight)
			vM.g = (vM.g * weightInv) + (color.g * weight)
			vM.b = (vM.b * weightInv) + (color.b * weight)
			
		end
	
	end
	
	function obj:maskRGBA(index, color, weight)
		
		if weight > 1 then weight = 1 elseif weight < 0 then weight = 0 end
		
		if     index == 1 then index = "r"
		elseif index == 2 then index = "g"
		elseif index == 3 then index = "b"
		else    			   index = "a" end
	
		for i = 1, self.baseVertexCount do
		
			local vM = self.modifiedVertices[i]
		
			local weight = weight * self.originalVertices[i][index]
			local weightInv = 1 - weight
			
			vM.r = (vM.r * weightInv) + (color.r * weight)
			vM.g = (vM.g * weightInv) + (color.g * weight)
			vM.b = (vM.b * weightInv) + (color.b * weight)
			vM.a = (vM.a * weightInv) + (color.a * weight)
			
		end
	
	end
	
	return obj

end