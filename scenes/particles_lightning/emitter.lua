
-----------------------------------------------------------------------------------------------
-- Lightning Emitter
-----------------------------------------------------------------------------------------------
function createLightningEmitter(image)

	customEmitter = createEmitter(image)
	
	customEmitter.offset.y = 0
	customEmitter.lightningStep = 1
	
	function customEmitter:update(dt) -- Lightning emitter override
	
		if self.timerEmission < 0.0 then
		
			-- Disable all particles
			
			for i = 1, self.count do
			
				self.particles[i].isAlive = false
				
			end
		
			-- Emit only the first particle, the rest will be emitted by each particle recursively
		
			local dir = vector(0, -0.1)
			
			dir:normalize()
			
			self.lightningStep = 1
		
			self.particles[1]:start(self.position.x, self.position.y, dir.x, dir.y)
			
			self.particles[1].distanceTravelled = 0
			
			self.timerEmission = 1.0
			
		end
		
		self.timerEmission = self.timerEmission - dt
		
		self:updateSpriteBatch(dt) -- This will update the particle mesh
	
	end
	
	return customEmitter

end
