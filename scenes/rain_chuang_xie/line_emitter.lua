-----------------------------------------------------------------------------------------------
-- Firework Emitter
-----------------------------------------------------------------------------------------------
function createRainEmitter(image, colorr, bottomEdge, aliveT, oX, oY)

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


	customEmitter.needScaleTransit = false
	customEmitter.particleScale = vector(0.02, 0.02)

	customEmitter.headPosition = vector(0, 0)
	customEmitter.velocity = vector(0, 0)
	customEmitter.headY = oY
	customEmitter.oriHeadY = oY
	customEmitter.headX = oX
	customEmitter.oriHeadX = oX
	
	customEmitter.highlightColor = color(1, 1, 1, 0)
	customEmitter.aliveTime = aliveT
	customEmitter.bottomEdge = bottomEdge
	customEmitter.oriBottomEdge = bottomEdge

	customEmitter.circleEmitter = nil
	customEmitter.dotEmitter = nil
	customEmitter.enabled = true

	
	function customEmitter:setDir(x, y)
	
		self.dirX = x
		self.dirY = y

		self.velocity.x = x * 0.1
		self.velocity.y = y * 0.1

		
	
	end

	function customEmitter:circleFinished()
		-- self.enabled = true		
		-- self.headY = self.oriHeadY
		-- self.headX = self.oriHeadX	
	end


	function customEmitter:update(dt) -- Firework emitter override
		self:updateSpriteBatch(dt) -- This will update the particle mesh

		if not self.enabled then
			return
		end

		self.position.x = self.position.x + (self.velocity.x * self.motionScale) -- Update position with velocity X
		self.position.y = self.position.y + (self.velocity.y * self.motionScale)-- Update position with velocity Y
		
		self.headY = self.headY + (self.velocity.y * self.motionScale)
		self.headX = self.headX + (self.velocity.x * self.motionScale)

	

		if self.headY < self.bottomEdge then
			self.circleEmitter:setPosition(self.headX, self.headY)	
			self.circleEmitter:start()

			self.dotEmitter:setPosition(self.headX, self.headY)	
			self.dotEmitter:start()
			


			self.headY = self.oriHeadY
			self.headX = self.oriHeadX + math.random() * 4
			self.bottomEdge = self.oriBottomEdge + (math.random() - 0.5) * 4
			-- self.enabled = false
		end

		-- if self.headY < self.bottomEdge then
		-- 	self.headY = self.oriHeadY
		-- 	self.headX = self.oriHeadX			
		-- end
		
		if self.innerEmission < 0.0 then		
			particle1 = self:getNextParticle()
			
			local colorGrey = colorCopy(GREY)
			
			colorGrey:set(0.2, 0.2, 0.2, 1)				
			if particle1 and self.headX > left and self.headX < right then
			
				particle1:start(self.headX, self.headY, self.aliveTime)
				-- particle1:update(dt) -- Push first particle 3 steps ahead		
				particle1.scale = self.particleScale
				particle1.dimTime = self.timerEmission
				-- particle1.dimColor = color(77/ 255, 192/ 255, 134 / 255, 1)
				particle1.dimColor = colorCopy(self.color)
				particle1.color:copy(self.color)				
				particle1.bottomEdge = self.bottomEdge
				particle1.direction = vector(self.dirX, self.dirY)
			end
		
			self.innerEmission = self.timerEmission
			
		end
		
		self.innerEmission = self.innerEmission - dt		
	
	
	end
	
	return customEmitter

end
