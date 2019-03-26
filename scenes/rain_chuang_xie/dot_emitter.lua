-----------------------------------------------------------------------------------------------
-- Firework Emitter
-----------------------------------------------------------------------------------------------
function createDotEmitter(image, colorr, aliveT)

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
	customEmitter.oriX = 0
	customEmitter.oriY = 0
	customEmitter.aliveTime = aliveT

	customEmitter.particleScale = vector(0.03, 0.03)
	

	function customEmitter:setPosition(oX, oY)
		self.oriX = oX
		self.oriY = oY
		self.offset.y = 1
	end

	function customEmitter:start()
		self.enabled = true

		for i = 1, 3 do
			if(self.enabled) then
				particle1 = self:getNextParticle()
	
				if particle1 and self.oriX > left and self.oriX < right then
				
					particle1:start(self.oriX, self.oriY, self.aliveTime)	
					particle1.scale = self.particleScale			
					particle1.color:copy(self.color)						

					particle1:setDir((i - 2) * (math.random() + 1), 1 + math.random() * 2)
				end
			end
		end
		
	end

	function customEmitter:finished()		
		self.lineEmitter:circleFinished()
	end


	function customEmitter:update(dt) -- Firework emitter override
		
		
		self:updateSpriteBatch(dt) -- This will update the particle mesh
	
	end
	
	return customEmitter

end
