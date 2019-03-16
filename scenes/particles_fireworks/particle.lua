
-----------------------------------------------------------------------------------------------
-- Lightning Particle 
-----------------------------------------------------------------------------------------------
function createFireworkParticle() 

	particle = { }
	
	particle.isAlive = false
	particle.system = nil
	particle.scale = vector(0.05, 0.05)
	particle.position = vector(0, 0)
	particle.direction = vector(1, 0)
	particle.velocity = vector(0, 0)
	particle.color = color(1, 0, 0)
	particle.timerAlive = 0
	
	function particle:start(posX, posY, dirX, dirY)
	
		self.isAlive = true
		self.timerAlive = 3.0
		
		self.position.x = posX
		self.position.y = posY
		
		self.velocity.x = dirX * 0.1
		self.velocity.y = dirY * 0.1
	
	end
	
	function particle:update(dt)
	
		if self.timerAlive > 0 then
			
			self.position.x = self.position.x + (self.velocity.x * self.system.motionScale) -- Update position with velocity X
			self.position.y = self.position.y + (self.velocity.y * self.system.motionScale) -- Update position with velocity Y
			
			self.position.y = self.position.y - (dt * 0.9) -- Apply a gravitational force (Y only)
			
			self.velocity.x = self.velocity.x * 0.98 -- Apply deceleration X
			self.velocity.y = self.velocity.y * 0.98 -- Apply deceleration Y
			
			self.timerAlive = self.timerAlive - dt
			
		else
		
			self.isAlive = false
		
		end
	
	end


	return particle

end

