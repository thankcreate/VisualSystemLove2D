
-----------------------------------------------------------------------------------------------
-- Lightning Particle 
-----------------------------------------------------------------------------------------------
function createWallParticle() 

	particle = { }
	
	particle.isAlive = false
	particle.system = nil
	-- particle.scale = vector(0.05, 0.05)
	particle.startScale = vector(0.05, 0.05)
	particle.endScale = vector(0.1, 0.05)

	particle.scale = vector(0.05, 0.05)
	particle.position = vector(0, 0)
	particle.direction = vector(0, -1)
	particle.velocity = vector(0, 0)
	particle.color = color(1, 0, 0)
	particle.timerAlive = 0
	particle.destY = 0
	particle.startY = 0

	particle.needScaleTransit = false

	function particle:start(posX, posY, dirX, dirY, deY)
	
		self.isAlive = true
		self.timerAlive = 10
		
		self.position.x = posX
		self.position.y = posY

		self.startY = posY
		
		self.velocity.x = dirX * 0.1
		self.velocity.y = dirY * 0.1

		self.destY = deY
	
	end
	
	function particle:update(dt)

		if self.velocity.y < 0 and self.position.y < self.destY then
			self.isAlive = false
		end

		if self.velocity.y > 0 and self.position.y > self.destY then
			self.isAlive = false
		end
	
		if self.timerAlive > 0 then
			
			self.position.x = self.position.x + (self.velocity.x * self.system.motionScale) -- Update position with velocity X
			self.position.y = self.position.y + (self.velocity.y * self.system.motionScale) -- Update position with velocity Y
			
			if self.needScaleTransit then 
				local perc = (self.position.y - self.startY) / (self.destY - self.startY)
				self.scale.x = (self.startScale.x + (self.endScale.x - self.startScale.x) * perc ) * overAllScaleFactor
				self.scale.y = (self.startScale.y + (self.endScale.y - self.startScale.y) * perc ) * overAllScaleFactor
			else 
				self.scale.x = self.startScale.x * overAllScaleFactor
				self.scale.y = self.startScale.y * overAllScaleFactor
			end

			self.timerAlive = self.timerAlive - dt			
		else
		
			self.isAlive = false
		
		end
	
	end


	return particle

end

