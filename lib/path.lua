require('lib/vector')

function specialNormal2D(p1, p2, p3) -- Helper function for createPath2d()

	local dirIn = vector(p2.x - p1.x, p2.y - p1.y)
	local dirOut = vector(p3.x - p2.x, p3.y - p2.y)

	dirIn:normalize()
	dirOut:normalize()
	
	-- Create vectors that are perpendicular to the in/out vectors.

	local n1 = vector(-dirIn.y, dirIn.x)
	local n2 = vector(-dirOut.y, dirOut.x)

	local nCombine = vector(n1.x + n2.x, n1.y + n2.y)
	local dCombine = vector(dirIn.x + dirOut.x, dirIn.y + dirOut.y)
	
	nCombine:normalize()
	dCombine:normalize()

	local dot = dot(dirIn, dCombine)

	if dot > 0 then
	
		nCombine.x = nCombine.x * (1.0 / dot)
		nCombine.y = nCombine.y * (1.0 / dot)
	
	end
	
	return nCombine
	
end

function createPath2D() -- Create a 2D path, which is just a series of vector points 

	local path = {}
	
	path.points = {}
	path.pointCount = 0
	path.distances = {}
	path.resolved = false
	
	function path:addPoint(x, y)
	
		self.pointCount = self.pointCount + 1
	
		self.points[self.pointCount] = vector(x, y)
		
		if self.pointCount == 1 then
			
			self.distances[self.pointCount] = 0
		
		else
		
			local v1 = self.points[self.pointCount]
			local v2 = self.points[self.pointCount - 1]
			
			local dif = vector(v1.x - v2.x, v1.y - v2.y)
			
			local length = length(dif)
			
			self.distances[self.pointCount] = self.distances[self.pointCount - 1] + length
		
		end
		
	end
	
	return path
	
end

 -- Create a flat mesh strip from a 2D path
 --
 -- The vertices will be colorized in the following way:
 -- 1. R = 1.0 for outer verts, 0.0 for inner verts
 -- 2. G = 1.0 for segment end verts, 0.0 for segment start verts
 -- 3. B = Paramaterized distance across whole path (0 at the start, 1 at the end)
 
function createMeshStrip2D(path, width, optionalColorTable)

	local useCustomColors = false

	if optionalColorTable and #optionalColorTable >= path.pointCount then

		useCustomColors = true
		
	end
	
	if path.pointCount > 2 then
	
		local vertices = {}
		local indices = {}
		
		local vertCount = 0
		local indexCount = 0
		
		local pPrev = vector(path.points[1].x, path.points[1].y) -- Point PREV (begins with LAST point)
		
		pPrev:add(vector(path.points[1].x - path.points[2].x, path.points[1].y - path.points[2].y))
		
		local p1 = vector(pPrev.x, pPrev.y)
		local p2 = vector(path.points[1].x, path.points[1].y)
		local p3 = vector(path.points[2].x, path.points[2].y)
		
		local normals = {}
		
		-- First pass: Find normals
		
		for i = 1, path.pointCount do
		
			p1.x = pPrev.x
			p1.y = pPrev.y
			
			p2.x = path.points[i].x
			p2.y = path.points[i].y
			
			if i < path.pointCount then
				
				p3.x = path.points[i + 1].x
				p3.y = path.points[i + 1].y
				
			else -- Final bar (where index is path.pointCount)
			
				p3.x = path.points[i].x
				p3.y = path.points[i].y
				
				p3:add(vector(path.points[i].x - path.points[i - 1].x, path.points[i].y - path.points[i - 1].y))
			
			end
			
			normals[i] = specialNormal2D(p1, p2, p3)
			
			pPrev.x = p2.x
			pPrev.y = p2.y
			
		end
	
		-- Second pass: Build mesh
		
		pPrev.x = path.points[1].x
		pPrev.y = path.points[1].y
		
		pPrev:add(vector(path.points[1].x - path.points[2].x, path.points[1].y - path.points[2].y))
		
		local colDistPrev = 0
		
		for i = 1, path.pointCount - 1 do
		
			p1.x = pPrev.x
			p1.y = pPrev.y
			
			p2.x = path.points[i].x
			p2.y = path.points[i].y
			
			local p2Normal = vector(0, 0)
			local p3Normal = vector(0, 0)
			
			p2Normal.x = normals[i].x
			p2Normal.y = normals[i].y
			
			local colDist2 = colDistPrev
			local colDist3 = 0
			
			if i < path.pointCount then
				
				p3.x = path.points[i + 1].x
				p3.y = path.points[i + 1].y
				
				p3Normal.x = normals[i + 1].x
				p3Normal.y = normals[i + 1].y
				
				colDist3 = path.distances[i + 1] / path.distances[path.pointCount]
				
			end
			
			local vc = vertCount
			local ic = indexCount
			
			--  2--3 
			--  | /| 
			--  |/ |
			--  1--4

			local s = width * 0.5
			
			local color1 = color(0, 0, colDist2, 1)
			local color2 = color(1, 0, colDist2, 1)
			local color3 = color(1, 1, colDist3, 1)
			local color4 = color(0, 1, colDist3, 1)
			
			if useCustomColors then
			
				color1 = optionalColorTable[i]
				color2 = optionalColorTable[i]
				color3 = optionalColorTable[i + 1]
				color4 = optionalColorTable[i + 1]
			
			end
			
			vertices[vc + 1] = { p2.x - (p2Normal.x * s), p2.y - (p2Normal.y * s),  p2Normal.x,  p2Normal.y, color1.r, color1.g, color1.b, color1.a }
			vertices[vc + 2] = { p2.x + (p2Normal.x * s), p2.y + (p2Normal.y * s),  p2Normal.x,  p2Normal.y, color2.r, color2.g, color2.b, color2.a }
			vertices[vc + 3] = { p3.x + (p3Normal.x * s), p3.y + (p3Normal.y * s),  p3Normal.x,  p3Normal.y, color3.r, color3.g, color3.b, color3.a }
			vertices[vc + 4] = { p3.x - (p3Normal.x * s), p3.y - (p3Normal.y * s),  p3Normal.x,  p3Normal.y, color4.r, color4.g, color4.b, color4.a }
			
			indices[ic + 1] = vc + 1
			indices[ic + 2] = vc + 3
			indices[ic + 3] = vc + 2
			
			indices[ic + 4] = vc + 1
			indices[ic + 5] = vc + 4
			indices[ic + 6] = vc + 3
			
			pPrev.x = p2.x
			pPrev.y = p2.y
			
			colDistPrev = colDist3
			
			vertCount = vertCount + 4
			indexCount = indexCount + 6
	
		end
		
		-- Build mesh
		
		meshLove = love.graphics.newMesh(vertices)
		
		meshLove:setVertexMap(indices)
		meshLove:setDrawMode("triangles")
		
		return meshLove
		
	end
	
	return nil

end