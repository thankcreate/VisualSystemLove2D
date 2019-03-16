
-----------------------------------------------------------------------------------------------
-- Lightning Particle 
-----------------------------------------------------------------------------------------------
function createLightningParticle() 

	particle = { }
	
	particle.isAlive = false
	particle.system = nil
	particle.scale = vector(0.05, 0.05)
	particle.position = vector(0, 0)
	particle.direction = vector(1, 0)
	particle.color = color(0.95, 0.95, 0.95)
	particle.length = 0.05 + (math.random() * 0.05)
	particle.timer = 0.1
	particle.tip = false
	
	function particle:start(posX, posY, dirX, dirY)
	
		self.isAlive = true
		self.tip = true
		self.position.x = posX
		self.position.y = posY
		self.direction.x = dirX
		self.direction.y = dirY
		self.scale.y = self.length * 1.0
		self.timer = 0
		
		self.direction:normalize()
	
	end
	
	function particle:update(dt)
	
		self.color.a = 1.0
	
		if self.timer < 0.0 and self.tip == true and self.position.y > 0 and self.system.lightningStep < self.system.count then
		
			-- Emit only the first particle, the rest will be emitted by each particle recursively
		
			local posX = self.position.x + (self.direction.x * self.length * 16)
			local posY = self.position.y + (self.direction.y * self.length * 16)
			local dirX = -0.5 + (math.random() * 1.0)
			local dirY = -0.5
			
			self.system.lightningStep = self.system.lightningStep + 1
			
			local p1 = self.system.particles[self.system.lightningStep]
		
			p1:start(posX, posY, dirX, dirY)
			
			p1.distanceTravelled = self.distanceTravelled + self.length
			
			-- Maybe start a new branch?
			
			if math.random() > 0.98 and self.system.lightningStep < self.system.count then
			
				self.system.lightningStep = self.system.lightningStep + 1
				
				local p2 = self.system.particles[self.system.lightningStep]
				
				p2:start(posX, posY, -dirX, dirY)
				
				p2.distanceTravelled = p1. distanceTravelled
			
			end
			
			-- No longer tip (so don't generate another particle segment)
			
			self.tip = false
		
		elseif self.timer < -1.1 then
		
			self.isAlive = false
		
		end
			
		self.timer = self.timer - dt
	
	end

	return particle

end

