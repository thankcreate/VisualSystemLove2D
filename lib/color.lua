-- Return an RGBA color

function colorCopy(c)

	return color(c.r, c.g, c.b, c.a)
	
end

function color(r, g, b, a)

	col = { r = r, g = g, b = b, a = a }
	
	function col:copy(c) -- Copy the RGBA values from another color
		
		self.r = c.r
		self.g = c.g
		self.b = c.b
		self.a = c.a
		
	end
	
	function col:set(r, g, b, a) -- Copy the RGBA values from another color
		
		self.r = r
		self.g = g
		self.b = b
		self.a = a
		
	end
	
	function col:blendRGB(c, weight) -- Blend RGB values with another color
	
		local weightInverse = (1 - weight)
		
		self.r = (self.r * weightInverse) + (c.r * weight)
		self.g = (self.g * weightInverse) + (c.g * weight)
		self.b = (self.b * weightInverse) + (c.b * weight)
	
	end
	
	function col:blendRGBA(c, weight) -- Blend RGBA values with another color
	
		local weightInverse = (1 - weight)
		
		self.r = (self.r * weightInverse) + (c.r * weight)
		self.g = (self.g * weightInverse) + (c.g * weight)
		self.b = (self.b * weightInverse) + (c.b * weight)
		self.a = (self.a * weightInverse) + (c.a * weight)
	
	end

	return col

end

-- Global colors
	
RED = color(1, 0, 0, 1)
BLUE = color(0, 0, 1, 1)
GREY = color(0.5, 0.5, 0.5, 1)
PINK = color(1, 0.6, 0.8, 1)
GREEN = color(0, 1, 0, 1)
ORANGE = color(0.9, 0.5, 0, 1)
YELLOW = color(1, 1, 0, 1)
MAGENTA = color(1, 0, 1, 1)
WHITE = color(1, 1, 1, 1)
BLACK = color(0, 0, 0, 1)
CLEAR = color(0, 0, 0, 0)

-- YIQ Rotation

matYIQ = matrix(0.299, 0.587, 0.114,   0.596, -0.274, -0.321,   0.211, -0.523, 0.311)
matRGB = matrix(1.000, 0.956, 0.621,   1.000, -0.272, -0.647,   1.000, -1.107, 1.705)

function shiftHue(color, radians, saturation, value)

	local VSU = value * saturation * math.cos(radians)
	local VSW = value * saturation * math.sin(radians)

	local r = (0.299 * value + 0.701 * VSU + 0.168 * VSW) * color.r 
		    + (0.587 * value - 0.587 * VSU + 0.330 * VSW) * color.g
		    + (0.114 * value - 0.114 * VSU - 0.497 * VSW) * color.b

	local g = (0.299 * value - 0.299 * VSU - 0.328 * VSW) * color.r
		    + (0.587 * value + 0.413 * VSU + 0.035 * VSW) * color.g
		    + (0.114 * value - 0.114 * VSU + 0.292 * VSW) * color.b

	local b = (0.299 * value - 0.3   * VSU + 1.25  * VSW) * color.r
		    + (0.587 * value - 0.588 * VSU - 1.05  * VSW) * color.g
		    + (0.114 * value + 0.886 * VSU - 0.203 * VSW) * color.b

	color.r = r
	color.g = g
	color.b = b
	
end
