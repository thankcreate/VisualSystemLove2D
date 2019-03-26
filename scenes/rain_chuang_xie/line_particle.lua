
-----------------------------------------------------------------------------------------------
-- Lightning Particle 
-----------------------------------------------------------------------------------------------
function createFireworkParticle() 

	particle = { }
	
	particle.isAlive = false
	particle.system = nil
	-- particle.scale = vector(0.05, 0.05)

	particle.scale = vector(0.05, 0.05)
	particle.position = vector(0, 0)
	particle.direction = vector(0, -1)
	particle.velocity = vector(0, 0)
	particle.color = color(1, 0, 0)
	particle.timerAlive = 0
	particle.maxAliveTime = 0
	-- this dim time is not fade out
	-- it's only a little bit dimmer than before
	particle.dimTime = 0	

	particle.dimColor = color(1,1,1)
	particle.bottomEdge = -100

	function particle:start(posX, posY, aliveTime)
	
		self.isAlive = true
		self.timerAlive = aliveTime
		self.maxAliveTime = aliveTime
		
		self.position.x = posX
		self.position.y = posY	
	end


	
	function particle:update(dt)
	
		self.color.a = self.timerAlive / self.maxAliveTime * 0.5 + 0.5

		-- the newly emitted particle should be brighter
		self.dimTime = self.dimTime - dt	
		if self.dimTime <= 0 then
			self.color = self.dimColor
		end

		-- if exceeded the bottom, deActive it
		if self.position.y < self.bottomEdge or self.position.y > top or self.position.x < left or self.position.x > right then
			self.isAlive = false
		end


	
		-- life time
		if self.timerAlive > 0 then
			self.timerAlive = self.timerAlive - dt			
		else
		
			self.isAlive = false
		
		end
	
	end


	return particle
end