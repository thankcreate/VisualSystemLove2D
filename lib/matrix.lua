
-- Prints out matrix values	to the console

function printMatrix(m)

	print(m[1][1], m[1][2], m[1][3], m[1][4]) -- Right
	print(m[2][1], m[2][2], m[2][3], m[2][4]) -- Up
	print(m[3][1], m[3][2], m[3][3], m[3][4]) -- Look
	print(m[4][1], m[4][2], m[4][3], m[4][4]) -- Position

end

 -- Returns a 4x4 matrix (3D) 

function mat4(x, y, z) return matrix(x, y, z) end

function matrix(x, y, z)

	mat = {{ 1, 0, 0, 0 },  -- Right vector 	(1, 0, 0)
		   { 0, 1, 0, 0 },  -- Up vector    	(0, 1, 0)
		   { 0, 0, 1, 0 },  -- Look vector  	(0, 0, 1)
		   { x, y, z, 1 }}  -- Position vector	(x, y, z)
		   
	function mat:identity() -- Function for reseting a matrix back to a base state (called the "identity" matrix)
	
		self[1][1] =  1 -- Right x
		self[1][2] =  0 -- Right y
		self[1][3] =  0 -- Right z
		self[1][4] =  0
	
		self[2][1] =  0 -- Up x
		self[2][2] =  1 -- Up y
		self[2][3] =  0 -- Up z
		self[2][4] =  0
	
		self[3][1] =  0 -- Look x
		self[3][2] =  0 -- Look y
		self[3][3] =  1 -- Look y
		self[3][4] =  0
	
		self[4][1] =  0 -- Pos x
		self[4][2] =  0 -- Pos y
		self[4][3] =  0 -- Pos z
		self[4][4] =  1
	
	end
	
	function mat:position(x, y, z) -- Function for setting the position xyz
	
		self[4][1] =  x -- Pos x
		self[4][2] =  y -- Pos y
		self[4][3] =  z -- Pos z
		
	end
	
	function mat:rotationRight(radians) -- Function for creating a rotation matrix along the "right" axis
	
		local c = math.cos(radians)
		local s = math.sin(radians)
	
		self[1][1] =  1 -- Right x
		self[1][2] =  0 -- Right y
		self[1][3] =  0 -- Right z
		self[1][4] =  0
	
		self[2][1] =  0 -- Up x
		self[2][2] =  c -- Up y
		self[2][3] = -s -- Up z
		self[2][4] =  0
	
		self[3][1] =  0 -- Look x
		self[3][2] =  s -- Look y
		self[3][3] =  c -- Look z
		self[3][4] =  0
	
		self[4][1] =  0 -- Pos x
		self[4][2] =  0 -- Pos y
		self[4][3] =  0 -- Pos z
		self[4][4] =  1
	
	end
	
	function mat:rotationUp(radians) -- Function for creating a rotation matrix along the "up" axis
	
		local c = math.cos(radians)
		local s = math.sin(radians)
	
		self[1][1] =  c -- Right x
		self[1][2] =  0 -- Right y
		self[1][3] =  s -- Right z
		self[1][4] =  0
	
		self[2][1] =  0 -- Up x
		self[2][2] =  1 -- Up y
		self[2][3] =  0 -- Up z
		self[2][4] =  0
	
		self[3][1] = -s -- Look x
		self[3][2] =  0 -- Look y
		self[3][3] =  c -- Look y
		self[3][4] =  0
	
		self[4][1] =  0 -- Pos x
		self[4][2] =  0 -- Pos y
		self[4][3] =  0 -- Pos z
		self[4][4] =  1
	
	end

	function mat:rotationLook(radians) -- Function for creating a rotation matrix along the "look" axis
	
		local c = math.cos(radians)
		local s = math.sin(radians)
	
		self[1][1] =  c -- Right x
		self[1][2] = -s -- Right y
		self[1][3] =  0 -- Right z
		self[1][4] =  0
	
		self[2][1] =  s -- Up x
		self[2][2] =  c -- Up y
		self[2][3] =  0 -- Up z
		self[2][4] =  0
	
		self[3][1] =  0 -- Look x
		self[3][2] =  0 -- Look y
		self[3][3] =  1 -- Look y
		self[3][4] =  0
	
		self[4][1] =  0 -- Pos x
		self[4][2] =  0 -- Pos y
		self[4][3] =  0 -- Pos z
		self[4][4] =  1
	
	end
	
	function mat:rotationAxis(radians, u, v, w)
	
		local L = (u*u + v * v + w * w)
		
		local u2 = u * u
		local v2 = v * v
		local w2 = w * w
		
		local cr = math.cos(radians)
		local sr = math.sin(radians)
		local sqrtL = math.sqrt(L)
	 
		self[1][1] = (u2 + (v2 + w2) * cr) / L
		self[1][2] = (u * v * (1 - cr) - w * sqrtL * sr) / L
		self[1][3] = (u * w * (1 - cr) + v * sqrtL * sr) / L
		self[1][4] = 0.0
	 
		self[2][1] = (u * v * (1 - cr) + w * sqrtL * sr) / L
		self[2][2] = (v2 + (u2 + w2) * cr) / L
		self[2][3] = (v * w * (1 - cr) - u * sqrtL * sr) / L
		self[2][4] = 0.0
	 
		self[3][1] = (u * w * (1 - cr) - v * sqrtL * sr) / L
		self[3][2] = (v * w * (1 - cr) + u * sqrtL * sr) / L
		self[3][3] = (w2 + (u2 + v2) * cr) / L
		self[3][4] = 0.0
	 
		self[4][1] = 0.0
		self[4][2] = 0.0
		self[4][3] = 0.0
		self[4][4] = 1.0
	
	end
	
	function mat:copy(m) -- Function for copying another matrix
		
		self[1][1] = m[1][1] -- Right x
		self[1][2] = m[1][2] -- Right y
		self[1][3] = m[1][3] -- Right z
		self[1][4] = m[1][4]
	
		self[2][1] = m[2][1] -- Up x
		self[2][2] = m[2][2] -- Up y
		self[2][3] = m[2][3] -- Up z
		self[2][4] = m[2][4]
		
		self[3][1] = m[3][1] -- Look x
		self[3][2] = m[3][2] -- Look y
		self[3][3] = m[3][3] -- Look z
		self[3][4] = m[3][4]
	
		self[4][1] = m[4][1] -- Pos x
		self[4][2] = m[4][2] -- Pos y
		self[4][3] = m[4][3] -- Pos z
		self[4][4] = m[4][4]
	
	end
	
	function mat:multiplyAB(m) -- Function for matrix multiplication (combining transformations in AB - order matters!)
	
		local s11 = self[1][1]
		local s12 = self[1][2]
		local s13 = self[1][3]
		local s14 = self[1][4]
		
		local s21 = self[2][1]
		local s22 = self[2][2]
		local s23 = self[2][3]
		local s24 = self[2][4]
		
		local s31 = self[3][1]
		local s32 = self[3][2]
		local s33 = self[3][3]
		local s34 = self[3][4]
		
		local s41 = self[4][1]
		local s42 = self[4][2]
		local s43 = self[4][3]
		local s44 = self[4][4]
		
		
		self[1][1] = (s11 * m[1][1]) + (s12 * m[2][1]) + (s13 * m[3][1]) + (s14 * m[4][1]) -- Row 1 vs Column 1 (Right x)
		self[1][2] = (s11 * m[1][2]) + (s12 * m[2][2]) + (s13 * m[3][2]) + (s14 * m[4][2]) -- Row 1 vs Column 2 (Right y)
		self[1][3] = (s11 * m[1][3]) + (s12 * m[2][3]) + (s13 * m[3][3]) + (s14 * m[4][3]) -- Row 1 vs Column 3 (Right z)
		self[1][4] = (s11 * m[1][4]) + (s12 * m[2][4]) + (s13 * m[3][4]) + (s14 * m[4][4]) -- Row 1 vs Column 4
	
		self[2][1] = (s21 * m[1][1]) + (s22 * m[2][1]) + (s23 * m[3][1]) + (s24 * m[4][1]) -- Row 2 vs Column 1 (Up x)
		self[2][2] = (s21 * m[1][2]) + (s22 * m[2][2]) + (s23 * m[3][2]) + (s24 * m[4][2]) -- Row 2 vs Column 2 (Up y)
		self[2][3] = (s21 * m[1][3]) + (s22 * m[2][3]) + (s23 * m[3][3]) + (s24 * m[4][3]) -- Row 2 vs Column 3 (Up z)
		self[2][4] = (s21 * m[1][4]) + (s22 * m[2][4]) + (s23 * m[3][4]) + (s24 * m[4][4]) -- Row 2 vs Column 4
	
		self[3][1] = (s31 * m[1][1]) + (s32 * m[2][1]) + (s33 * m[3][1]) + (s34 * m[4][1]) -- Row 3 vs Column 1 (Look x)
		self[3][2] = (s31 * m[1][2]) + (s32 * m[2][2]) + (s33 * m[3][2]) + (s34 * m[4][2]) -- Row 3 vs Column 2 (Look y)
		self[3][3] = (s31 * m[1][3]) + (s32 * m[2][3]) + (s33 * m[3][3]) + (s34 * m[4][3]) -- Row 3 vs Column 3 (Look z)
		self[3][4] = (s31 * m[1][4]) + (s32 * m[2][4]) + (s33 * m[3][4]) + (s34 * m[4][4]) -- Row 3 vs Column 4
		
		self[4][1] = (s41 * m[1][1]) + (s42 * m[2][1]) + (s43 * m[3][1]) + (s44 * m[4][1]) -- Row 4 vs Column 1 (Look x)
		self[4][2] = (s41 * m[1][2]) + (s42 * m[2][2]) + (s43 * m[3][2]) + (s44 * m[4][2]) -- Row 4 vs Column 2 (Look y)
		self[4][3] = (s41 * m[1][3]) + (s42 * m[2][3]) + (s43 * m[3][3]) + (s44 * m[4][3]) -- Row 4 vs Column 3 (Look z)
		self[4][4] = (s41 * m[1][4]) + (s42 * m[2][4]) + (s43 * m[3][4]) + (s44 * m[4][4]) -- Row 4 vs Column 4
		
	end
	
	function mat:multiplyBA(m) -- Function for matrix multiplication (combining transformations in BA order - order matters!)
	
		local s11 = self[1][1]
		local s12 = self[1][2]
		local s13 = self[1][3]
		local s14 = self[1][4]
		
		local s21 = self[2][1]
		local s22 = self[2][2]
		local s23 = self[2][3]
		local s24 = self[2][4]
		
		local s31 = self[3][1]
		local s32 = self[3][2]
		local s33 = self[3][3]
		local s34 = self[3][4]
		
		local s41 = self[4][1]
		local s42 = self[4][2]
		local s43 = self[4][3]
		local s44 = self[4][4]
		
		
		self[1][1] = (m[1][1] * s11) + (m[1][2] * s21) + (m[1][3] * s31) + (m[1][4] * s41) -- Row 1 vs Column 1 (Right x)
		self[1][2] = (m[1][1] * s12) + (m[1][2] * s22) + (m[1][3] * s32) + (m[1][4] * s42) -- Row 1 vs Column 2 (Right y)
		self[1][3] = (m[1][1] * s13) + (m[1][2] * s23) + (m[1][3] * s33) + (m[1][4] * s43) -- Row 1 vs Column 3 (Right z)
		self[1][4] = (m[1][1] * s14) + (m[1][2] * s24) + (m[1][3] * s34) + (m[1][4] * s44) -- Row 1 vs Column 4
	
		self[2][1] = (m[2][1] * s11) + (m[2][2] * s21) + (m[2][3] * s31) + (m[2][4] * s41) -- Row 2 vs Column 1 (Up x)
		self[2][2] = (m[2][1] * s12) + (m[2][2] * s22) + (m[2][3] * s32) + (m[2][4] * s42) -- Row 2 vs Column 2 (Up y)
		self[2][3] = (m[2][1] * s13) + (m[2][2] * s23) + (m[2][3] * s33) + (m[2][4] * s43) -- Row 2 vs Column 3 (Up z)
		self[2][4] = (m[2][1] * s14) + (m[2][2] * s24) + (m[2][3] * s34) + (m[2][4] * s44) -- Row 2 vs Column 4
	
		self[3][1] = (m[3][1] * s11) + (m[3][2] * s21) + (m[3][3] * s31) + (m[3][4] * s41) -- Row 3 vs Column 1 (Look x)
		self[3][2] = (m[3][1] * s12) + (m[3][2] * s22) + (m[3][3] * s32) + (m[3][4] * s42) -- Row 3 vs Column 2 (Look y)
		self[3][3] = (m[3][1] * s13) + (m[3][2] * s23) + (m[3][3] * s33) + (m[3][4] * s43) -- Row 3 vs Column 3 (Look z)
		self[3][4] = (m[3][1] * s14) + (m[3][2] * s24) + (m[3][3] * s34) + (m[3][4] * s44) -- Row 3 vs Column 4
		
		self[4][1] = (m[4][1] * s11) + (m[4][2] * s21) + (m[4][3] * s31) + (m[4][4] * s41) -- Row 4 vs Column 1 (Look x)
		self[4][2] = (m[4][1] * s12) + (m[4][2] * s22) + (m[4][3] * s32) + (m[4][4] * s42) -- Row 4 vs Column 2 (Look y)
		self[4][3] = (m[4][1] * s13) + (m[4][2] * s23) + (m[4][3] * s33) + (m[4][4] * s43) -- Row 4 vs Column 3 (Look z)
		self[4][4] = (m[4][1] * s14) + (m[4][2] * s24) + (m[4][3] * s34) + (m[4][4] * s44) -- Row 4 vs Column 4
		
	end
	
	function mat:invert() 
		
		local rV = { self[1][1], self[1][2], self[1][3] } -- The right vector
		local uV = { self[2][1], self[2][2], self[2][3] } -- The up vector
		local lV = { self[3][1], self[3][2], self[3][3] } -- The look vector
		local pV = { self[4][1], self[4][2], self[4][3] } -- The position vector
		
		local lRight = 1.0 / math.sqrt((self[1][1] * self[1][1]) + (self[1][2] * self[1][2]) + (self[1][3] * self[1][3]))
		local lUp    = 1.0 / math.sqrt((self[2][1] * self[2][1]) + (self[2][2] * self[2][2]) + (self[2][3] * self[2][3]))
		local lLook  = 1.0 / math.sqrt((self[3][1] * self[3][1]) + (self[3][2] * self[3][2]) + (self[3][3] * self[3][3]))

		local lRSq = lRight * lRight
		local lUSq = lUp * lUp
		local lLSq = lLook * lLook
		
		local x = -((pV[1] * rV[1]) + (pV[2] * rV[2]) + (pV[3] * rV[3])) * lRSq -- 3D dot product
		local y = -((pV[1] * uV[1]) + (pV[2] * uV[2]) + (pV[3] * uV[3])) * lUSq -- 3D dot product
		local z = -((pV[1] * lV[1]) + (pV[2] * lV[2]) + (pV[3] * lV[3])) * lLSq -- 3D dot product

		self[1][1] = rV[1] * lRSq
		self[1][2] = uV[1] * lUSq
		self[1][3] = lV[1] * lLSq
		self[1][4] = 0
		
		self[2][1] = rV[2] * lRSq
		self[2][2] = uV[2] * lUSq
		self[2][3] = lV[2] * lLSq
		self[2][4] = 0
		
		self[3][1] = rV[3] * lRSq
		self[3][2] = uV[3] * lUSq
		self[3][3] = lV[3] * lLSq
		self[3][4] = 0
		
		self[4][1] = x
		self[4][2] = y
		self[4][3] = z
		self[4][4] = 1
		
	end

	return mat

end