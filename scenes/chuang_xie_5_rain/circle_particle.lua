
-----------------------------------------------------------------------------------------------
-- Lightning Particle 
-----------------------------------------------------------------------------------------------
function createCircleParticle() 

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
	particle.emitter = nil

	particle.maxAliveTime = 0


	function particle:start(posX, posY, aliveTime)
	
		self.isAlive = true
		self.timerAlive = aliveTime -- current	
		self.maxAliveTime = aliveTime -- max
		
		self.position.x = posX
		self.position.y = posY	
	end
	
	function particle:update(dt)

		-- scale 0 - > 0.05
		-- time max - > 0
		local scaleV = (1 - self.timerAlive / self.maxAliveTime) * 0.1
		self.scale = vector(scaleV, scaleV)
		
		
		self.color.a = self.timerAlive / self.maxAliveTime * 0.2 + 0.8
		
		
		-- life time
		if self.timerAlive > 0 then						
			self.timerAlive = self.timerAlive - dt			
		else
			self.emitter:finished()
			self.isAlive = false		
		end
	
	end


	return particle
end