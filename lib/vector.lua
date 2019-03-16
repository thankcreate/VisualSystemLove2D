PI = 3.14159

function angle2D(vec) -- Function for returning the angle of a vector in radians (not accounting for Z)

	local arcTan = math.atan2(vec.x, vec.y)
	
	if vec.x < 0 then 
	
		return (2 * PI) - (arcTan * -1)
		
	else 
	
		return arcTan
		
	end

end

function dot(vec1, vec2) -- Return a the dot product of 2 vectors

	-- The dot product is a scalar value (not a vector) that describes the similarity between
	-- two vectors. If the two vectors being compared are identical, the dot product will be 1.
	-- If the vectors are exactly perpendicular to each other, the dot product will be 0.
	-- If the vectors are pointing in opposite directions, the dot product will be -1.
	-- Those values assume that the two vectors have a length of 1 (they're normalized).

	return (vec1.x * vec2.x) + (vec1.y * vec2.y) + (vec1.z * vec2.z)

end

function length(vec) -- Return the squared length of a vector

	local lengthSq = (vec.x * vec.x) + (vec.y * vec.y) + (vec.z * vec.z)
	
	return math.sqrt(lengthSq)

end

function lengthSq(vec) -- Return the squared length of a vector

	return (vec.x * vec.x) + (vec.y * vec.y) + (vec.z * vec.z)

end

function vectorCross(vec1, vec2) -- Return the cross product of 2 vectors

	return vector((vec1.y * vec2.z) - (vec2.y * vec1.z), (vec1.z * vec2.x) - (vec2.z * vec1.x), (vec1.x * vec2.y) - (vec2.x * vec1.y))

end

function vectorAdd(vec1, vec2) -- New vector by adding two vectors

	return vector(vec1.x + vec2.x, vec1.y + vec2.y, vec1.z + vec2.z)

end

function vectorSubtract(vec1, vec2) -- New vector by subtracting two vectors

	return vector(vec1.x - vec2.x, vec1.y - vec2.y, vec1.z - vec2.z)

end

function vectorCopy(vec) -- New vector with data copied from another vector

	return vector(vec.x, vec.y, vec.z)

end

-- Return a 2D vector 

function vector(x, y, z)

	if z == nil then z = 0 end

	local vec = { x = x, y = y, z = z }
	
	function vec:copy(vector) -- Copy values from another vector
	
		self.x = vector.x
		self.y = vector.y
		self.z = vector.z
	
	end
	
	function vec:set(x, y, z)
	
		self.x = x
		self.y = y
		self.z = z
		
	end
	
	function vec:multiply(scalar) -- Multiply (scale) components by a value
	
		self.x = self.x * scalar
		self.y = self.y * scalar
		self.z = self.z * scalar
	
	end

	function vec:add(vector) -- Add values from another vector
	
		self.x = self.x + vector.x
		self.y = self.y + vector.y
		self.z = self.z + vector.z
	
	end

	function vec:subtract(vector) -- Subtract values from another vector
	
		self.x = self.x - vector.x
		self.y = self.y - vector.y
		self.z = self.z - vector.z
	
	end

	function vec:normalize() -- Normalize (make length equal to 1.0)
	
		local length = (self.x * self.x) + (self.y * self.y) + (self.z * self.z)
		
		if length > 0 then 
			
			length = math.sqrt(length) 
		
			self.x = self.x / length;
			self.y = self.y / length;
			self.z = self.z / length;
		
		else
		
			self.x = 0
			self.y = 0
			self.z = 0
			
		end
	
	end
	
	function vec:transformDirection(m) -- Transform by a matrix, without position influence (notice the fourth matrix row/vector isn't here)
	
		local x = self.x
		local y = self.y
		local z = self.z
		
		self.x = (x * m[1][1]) + (y * m[2][1]) + (z * m[3][1]) -- X vs Column 1
		self.y = (x * m[1][2]) + (y * m[2][2]) + (z * m[3][2]) -- Y vs Column 2
		self.z = (x * m[1][3]) + (y * m[2][3]) + (z * m[3][3]) -- Z vs Column 3
	
	end
	
	function vec:transformPosition(m) -- Transform by a matrix, including position influence (notice the inclusion of the fourth matrix row/vector)
		
		local x = self.x
		local y = self.y
		local z = self.z
		
		self.x = (x * m[1][1]) + (y * m[2][1]) + (z * m[3][1]) + m[4][1] -- X vs Column 1
		self.y = (x * m[1][2]) + (y * m[2][2]) + (z * m[3][2]) + m[4][2] -- Y vs Column 2
		self.z = (x * m[1][3]) + (y * m[2][3]) + (z * m[3][3]) + m[4][3] -- Z vs Column 3
		
		return  (x * m[1][4]) + (y* m[2][4]) + (z * m[3][4]) + m[4][4]  -- Return w component
	
	end
	
	return vec

end
