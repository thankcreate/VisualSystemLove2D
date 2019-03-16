require('lib/color')

-- Return custom particle emitter whose update() function should be overridden with custom behavior

function createEmitter(image)

	ps = {}
	
	ps.spriteBatch = love.graphics.newSpriteBatch(image, count)
	ps.image = image
	ps.offset = vector(0, 0)
	ps.count = 0
	ps.particles = {}
	ps.position = vector(0, 0) -- Set by object holding the emitter
	ps.scale = vector(1, 1)    -- Set by object holding the emitter
	ps.color = color(1, 1, 1, 0)
	ps.timerEmission = 0.25
	ps.timerGeneral = 0.0
	ps.returnIndex = 1
	
	if image then ps.offset.x, ps.offset.y = image:getDimensions() * 0.5 end -- Center of image
	
	function ps:addParticle(particle) -- Function for adding a particle (this is not the same as emitting a particle)
	
		self.count = self.count + 1
	
		self.particles[self.count] = particle
		
		particle.system = self
		
	end
	
	function ps:getNextParticle()
	
		self.returnIndex = (self.returnIndex % self.count) + 1
		
		return self.particles[self.returnIndex]
	
	end

	function ps:updateSpriteBatch(dt) -- Function for updating Love's sprite batch (call every frame, unless drawing something static)

		-- Clear the batch (last frame's particles)
		
		self.spriteBatch:clear()
		
		-- Sprite batch wants an offset to build the sprite geometry from
		
		local imageOffsetX = self.offset.x 
		local imageOffsetY = self.offset.y 
		
		-- Add all of the 'alive' particle sprites
		
		for i = 1, self.count do

			local p = self.particles[i]
			
			if p.isAlive then
			
				p:update(dt)
			
				local s = p.scale
				local a = angle2D(p.direction) -- Angle in radians
				
				self.spriteBatch:setColor(p.color.r, p.color.g, p.color.b, p.color.a) 
				self.spriteBatch:add(p.position.x * self.scale.x, p.position.y * self.scale.y, -a, s.x * self.scale.x, s.y * self.scale.y, imageOffsetX, imageOffsetY)
				--self.spriteBatch:add(p.position.x, p.position.y * 0.2, -a, s.x, s.y, imageOffsetX, imageOffsetY)
				
			end

		end		

	end

	function ps:update(dt) -- Function for defining custom system/emitter behavior and for updating the sprite batch...
	
		-- An emitter can be defined here...
		--
		-- For each particle that needs to be emitted, the list can be iterated in search of dead particles
		-- that can be revived with their start(posX, posY, dirX, dirY) function
		--
		-- Below is an example based on time and where the particles emit from the emitter's position
		
		self.timerEmission = self.timerEmission - dt
		
		self.color.a = math.abs(math.sin(self.timerGeneral * 5.0))
	
		if self.timerEmission < 0 then
		
			local numToEmit = 3
		
			for i = 1, self.count do
			
				local p = self.particles[i]
				
				if p.isAlive == false then -- Found an available particle to emit...
					
					p.isAlive = true
					
					local direction = vector(-0.1 + (math.random() * 0.2), 0.9 + (math.random() * 0.2)) -- Determine its direction
				
					p:start(self.position.x, self.position.y, direction.x, direction.y)
					
					numToEmit = numToEmit - 1
				
					if numToEmit == 0 then break end
				
				end
			
			end
			
			self.timerEmission = 0.25
			
		end
		
		self.timerGeneral = self.timerGeneral + dt
		
		self:updateSpriteBatch(dt) -- This will update the particles
	
	end
	
	function ps:drawParticles() -- Function for drawing the sprite batch
		
		-- Draw sprite batch
		
		love.graphics.draw(self.spriteBatch)	

	end
	
	return ps

end

 -- Particle Example
 
function createParticleExample() 
		
	-- Give this particle some table values and a local update function

	particle = {}
	
	particle.isAlive = false
	particle.system = nil
	particle.timer = 0.0
	particle.scale = vector(0.05, 0.05)
	particle.color = color(math.random(), math.random(), math.random(), 1)
	particle.position = vector(0, 0)
	particle.direction = vector(1, 0)
	
	function particle:start(posX, posY, dirX, dirY)
	
		self.isAlive = true
		self.timer = 1.0 + (math.random() * 3.0)
		self.position.x = posX
		self.position.y = posY
		self.direction.x = dirX
		self.direction.y = dirY
		
		self.direction:normalize()
	
	end
	
	function particle:update(dt)
	
		-- Update position
	
		local speed = 0.2
	
		self.position.x = self.position.x + (self.direction.x * speed)
		self.position.y = self.position.y + (self.direction.y * speed)
		
		-- Update timer (though it is not necessary to have particle life operate on a timer...)
		
		self.timer = self.timer - 0.01
		
		if self.timer < 0.0 then
		
			self.isAlive = false -- The system will see that this particle is no longer alive and then remove it
		
		end
			
	end

	return particle
	
end
