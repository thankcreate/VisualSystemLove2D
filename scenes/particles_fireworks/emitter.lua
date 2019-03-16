-----------------------------------------------------------------------------------------------
-- Firework Emitter
-----------------------------------------------------------------------------------------------
function createFireworkEmitter(image, color)

	customEmitter = createEmitter(image)
	
	--customEmitter.offset.y = image:getHeight()
	customEmitter.color:copy(color)
	customEmitter.lightningStep = 1
	customEmitter.fireworkPoints = {}
	customEmitter.timerEmission = 0.0
	customEmitter.motionScale = 0.1
	
	function customEmitter:setFireworkShape(mesh)
	
		if mesh then
		
			self.fireworkPoints = {} -- Replace with empty table
		
			for i = 1, mesh:getVertexCount() do
			
				local x, y = mesh:getVertex(i)
			
				self.fireworkPoints[i] = { x, y }
			
			end
			
		end
		
	end
	
	function customEmitter:update(dt) -- Firework emitter override
	
		if self.timerEmission < 0.0 and #self.fireworkPoints > 0 then
	
			local releaseCount = #self.fireworkPoints
			
			if self.count < releaseCount then releaseCount = self.count end
			
			for i = 1, releaseCount do
			
				local point = self.fireworkPoints[i]
				
				local rx = (math.random() - 0.5) * 0.2 -- Random offset X
				local ry = (math.random() - 0.5) * 0.2 -- Random offset Y
				
				particle1 = self:getNextParticle()
				particle2 = self:getNextParticle()
				particle3 = self:getNextParticle()
				particle4 = self:getNextParticle()
				
				local colorGrey = colorCopy(GREY)
				
				colorGrey:set(0.2, 0.2, 0.2, 1)
					
				if particle1 and particle2 and particle3 and particle4 then
				
					particle1:start(self.position.x, self.position.y, point[1] + rx, point[2] + ry)
					particle2:start(self.position.x, self.position.y, point[1] + rx, point[2] + ry)
					particle3:start(self.position.x, self.position.y, point[1] + rx, point[2] + ry)
					particle4:start(self.position.x, self.position.y, point[1] + rx, point[2] + ry)
					
					particle1:update(dt) -- Push first particle 3 steps ahead
					particle1:update(dt)
					particle1:update(dt)
					
					particle2:update(dt) -- Push second particle 2 steps ahead
					particle2:update(dt)
				
					particle3:update(dt) -- Push third particle 1 step ahead
					
					-- Fade trail particles toward grey
					
					particle1.color:copy(self.color)
					particle2.color:copy(self.color)
					particle3.color:copy(self.color)
					particle4.color:copy(self.color)
					
					particle2.color:blendRGB(colorGrey, 0.3)
					particle3.color:blendRGB(colorGrey, 0.6)
					particle4.color:blendRGB(colorGrey, 0.9)
					
				end
				
			end
			
			self.timerEmission = 3.0
			
		end
		
		self.timerEmission = self.timerEmission - dt
		
		self:updateSpriteBatch(dt) -- This will update the particle mesh
	
	end
	
	return customEmitter

end
