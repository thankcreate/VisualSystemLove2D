
-- Global shader uniforms for objects to update individually (not all uniforms used by all shaders)

uniformWorldObject = mat4()
uniformWorldCamera = mat4()
uniformWorldViewProj = mat4()
uniformColorBlend = vector()
uniformAlpha = 1.0

-- Return our own shader object containing a love2D shader

function createShader(vertexShader, pixelShader) 

	shader = {}
	
	shader.source = love.graphics.newShader(globalScenePath .. vertexShader, globalScenePath .. pixelShader)
	
	function shader:updateUniforms() -- Function for updating a unique set of uniforms
	
		local s = self.source
		local m = flipMatrix(uniformWorldViewProj) -- Matrix sent to shader needs to be switched from column-major to row-major
	
		if s:hasUniform("worldViewProj") then s:send("worldViewProj", m) end
		if s:hasUniform("alpha") then s:send("alpha", uniformAlpha * 1.0) end
		if s:hasUniform("colorBlend") then s:send("colorBlend", { uniformColorBlend.r, uniformColorBlend.g, uniformColorBlend.b, uniformColorBlend.a }) end
	
	end

	return shader

end

-- Flip matrix organization

function flipMatrix(mat)
	
	local m = mat4()
		
	-- a1 a2 a3 a4    
	-- b1 b2 b3 b4  
	-- c1 c2 c3 c4 
	-- d1 d2 d3 d4
	--
	--     to
	--
	-- a1 b1 c1 d1    
	-- a2 b2 c2 d2   
	-- a3 b3 c3 d3  
	-- a4 b4 c4 d4
	
	m[1][1] = mat[1][1]
	m[1][2] = mat[2][1]
	m[1][3] = mat[3][1]
	m[1][4] = mat[4][1]
	
	m[2][1] = mat[1][2]
	m[2][2] = mat[2][2]
	m[2][3] = mat[3][2]
	m[2][4] = mat[4][2]
	
	m[3][1] = mat[1][3]
	m[3][2] = mat[2][3]
	m[3][3] = mat[3][3]
	m[3][4] = mat[4][3]
	
	m[4][1] = mat[1][4]
	m[4][2] = mat[2][4]
	m[4][3] = mat[3][4]
	m[4][4] = mat[4][4]
	
	return m

end