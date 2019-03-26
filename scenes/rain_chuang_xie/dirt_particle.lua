
-----------------------------------------------------------------------------------------------
-- Lightning Particle 
-----------------------------------------------------------------------------------------------
function createDirtParticle() 

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
	particle.oriColor = color(1, 0, 0)

	particle.maxAliveTime = 0


	particle.amplitude = 1
	particle.totalTime = 0
	particle.oriX = 0
	particle.phase = 0

	function particle:start(posX, posY, aliveTime)
	
		self.isAlive = true
		self.timerAlive = aliveTime -- current	
		self.maxAliveTime = aliveTime -- max
		
		self.position.x = posX
		self.oriX = posX
		self.position.y = posY
		
		self.amplitude = math.random() * 2 + 2
		self.phase = math.random() * 3.14
	end

	function particle:setDir(dirX, dirY)
		self.direction = vector(dirX, dirY)
		self.velocity = vector(dirX * 0.8, dirY * 0.8)
	end
	
	

	function particle:update(dt)

		self.totalTime = self.totalTime + dt

		if self.position.y < bottom  then
			self.isAlive = false
		end

		self.color = colorCopy(self.oriColor);
		if self.position.y > top or self.position.x > right or self.position.x < left then			
			self.color.a = 0
		end
		

		self.position.x = self.oriX + (math.sin(self.totalTime * DIRT_FREQUENCY + self.phase ) * self.amplitude * DIRT_AMPLITUDE) -- Update position with velocity X
		self.position.y = self.position.y + (self.velocity.y * self.system.motionScale) -- Update position with velocity Y
		
	
	end
	return particle
end