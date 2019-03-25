
-----------------------------------------------------------------------------------------------
-- Lightning Particle 
-----------------------------------------------------------------------------------------------
function createDotParticle() 

	particle = { }
	
	particle.isAlive = false
	particle.system = nil
	-- particle.scale = vector(0.05, 0.05)

	particle.scale = vector(0.03, 0.03)
	particle.position = vector(0, 0)
	particle.direction = vector(0, -1)
	particle.velocity = vector(0, 0)
	particle.color = color(1, 0, 0)
	particle.timerAlive = 0

	particle.maxAliveTime = 0



	function particle:start(posX, posY, aliveTime)
	
		self.isAlive = true
		self.timerAlive = aliveTime -- current	
		self.maxAliveTime = aliveTime -- max
		
		self.position.x = posX
		self.position.y = posY	
	end

	function particle:setDir(dirX, dirY)
		self.direction = vector(dirX, dirY)
		self.velocity = vector(dirX * 0.8, dirY * 0.8)
	end
	
	function particle:update(dt)

		if self.position.y < bottom or self.position.y > top or self.position.x < left or self.position.x > right then
			self.isAlive = false
		end

		-- scale 0 - > 0.05
		-- time max - > 0
		-- local scaleV = (1 - self.timerAlive / self.maxAliveTime) * 0.1
		-- self.scale = vector(scaleV, scaleV)
		
		
		-- self.color.a = self.timerAlive / self.maxAliveTime * 0.2 + 0.8
		self.velocity.y = self.velocity.y - dt *  2
		self.direction = vector(self.velocity.x, self.velocity.y)

		self.position.x = self.position.x + (self.velocity.x * self.system.motionScale) -- Update position with velocity X
		self.position.y = self.position.y + (self.velocity.y * self.system.motionScale) -- Update position with velocity Y
		
		-- life time
		if self.timerAlive > 0 then						
			self.timerAlive = self.timerAlive - dt			
		else
			self.isAlive = false		
		end
	
	end


	return particle
end