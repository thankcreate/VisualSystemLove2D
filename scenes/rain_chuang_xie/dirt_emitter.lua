-----------------------------------------------------------------------------------------------
-- Firework Emitter
-----------------------------------------------------------------------------------------------
function createDirtEmitter(image, colorr, oX, oY)

	customEmitter = createEmitter(image)
	
	--customEmitter.offset.y = image:getHeight()
	customEmitter.color:copy(colorr)
	customEmitter.lightningStep = 1
	customEmitter.fireworkPoints = {}
	customEmitter.timerEmission = 0.0
	customEmitter.motionScale = 0.1
	customEmitter.dirX = 0
	customEmitter.dirY = 0
	customEmitter.innerEmission = 0.0
	customEmitter.enabled = true
	customEmitter.oriX = oX
	customEmitter.oriY = oY


	customEmitter.particleScale = vector(0.06, 0.06)
	



	function customEmitter:update(dt) -- Firework emitter override
		
		
		if self.innerEmission < 0.0 then		
			particle1 = self:getNextParticle()
	
			if particle1 and self.oriX > left and self.oriX < right then
			
				particle1:start(self.oriX, self.oriY, self.aliveTime)	
				local factor = math.random() * 1 + 0.5
				particle1.scale = vector(self.particleScale.x * factor, self.particleScale.y * factor)			
				particle1.color:copy(self.color)			
				particle1.oriColor:copy(self.color)

				particle1:setDir(0, -0.5)
				
			end
		
			self.innerEmission = math.random() * 5 + 5
			
		end
		
		self.innerEmission = self.innerEmission - dt		
		self:updateSpriteBatch(dt) -- This will update the particle mesh
	
	end
	
	return customEmitter

end
