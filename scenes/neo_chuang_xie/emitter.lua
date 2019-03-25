-----------------------------------------------------------------------------------------------
-- Wall Emitter
-----------------------------------------------------------------------------------------------
function createWallEmitter(image, color, y, firstDelayCount)

	customEmitter = createEmitter(image)
	
	--customEmitter.offset.y = image:getHeight()
	customEmitter.color:copy(color)
	customEmitter.lightningStep = 1
	customEmitter.fireworkPoints = {}
	customEmitter.timerEmission = 0.0
	customEmitter.motionScale = 0.1
	customEmitter.dirX = 0
	customEmitter.dirY = 0
	customEmitter.innerEmission = 0.0
	customEmitter.destY = y

	customEmitter.needScaleTransit = false
	customEmitter.particleScale = vector(0.05, 0.05)
	customEmitter.firstDelayCount = firstDelayCount

	function customEmitter:setDir(x, y)
	
		self.dirX = x
		self.dirY = y
	
	end
	
	function customEmitter:update(dt) -- Firework emitter override
	
		if self.innerEmission < 0.0 then		
			
			local rx = self.dirX -- Random offset X
			local ry = self.dirY -- Random offset Y
			
			particle1 = self:getNextParticle()
			local colorGrey = colorCopy(GREY)
			
			colorGrey:set(0.2, 0.2, 0.2, 1)				
			if particle1 then
			
				particle1:start(self.position.x, self.position.y, rx, ry, self.destY)
				-- particle1:update(dt) -- Push first particle 3 steps ahead		
				
				particle1.scale = vectorCopy(self.particleScale)
				particle1.startScale = vectorCopy(self.particleScale)
				particle1.needScaleTransit = self.needScaleTransit
				particle1.color:copy(self.color)
			end
		
			self.innerEmission = self.timerEmission
			
		end
		
		self.innerEmission = self.innerEmission - dt		
		self:updateSpriteBatch(dt) -- This will update the particle mesh
	
	end
	
	return customEmitter

end
