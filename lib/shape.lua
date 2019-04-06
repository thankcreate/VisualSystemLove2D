require('lib/fbx')

-- Create a circle

function createMeshCircle(pointCount, radius, colorCenter, colorEdge)

	local step = (math.pi * 2) / pointCount
	
	local vertices = 
	{
	--	2--3+
	--	| / 
	--	|/  
	--	1  <-- Center     
	--
		{ 0, 0, 0, 0.5, 0.5, colorCenter.r, colorCenter.g, colorCenter.b, colorCenter.a, 0, 0, 1 } -- Center
	}
	
	for i = 2, pointCount + 2 do -- Starts at second index (because first is the center)
	
		local u = math.sin(step * i)
		local v = math.cos(step * i)
		
		vertices[i] = { u * radius, v * radius, 0,  0.5 + (u * 0.5), 0.5 + (v * 0.5), colorEdge.r, colorEdge.g, colorEdge.b, colorEdge.a, 0, 0, 1  }
	
	end
	
	local attr1 = { "VertexPosition", "float", 3 }
	local attr2 = { "VertexTexCoord", "float", 2 }
	local attr3 = { "VertexColor", "byte", 4 }
	local attr4 = { "VertexNormal", "float", 3 }

	local meshLove = love.graphics.newMesh({ attr1, attr2, attr3, attr4 }, vertices, "fan", "dynamic")
	
	return meshLove

end

-- Create a rectangle

function createMeshRectangle(left, right, top, bottom, colorTL, colorTR, colorBL, colorBR)

	local vertices = 
	{
	--	1--2
	--	| /|
	--	|/ |
	--	4--3
	--
	--   		Pos XYZ        UV (ignore)                 Color RGBA				   Normal XYZ
        {    left,     top, 0,    0, 1,    colorTL.r, colorTL.g, colorTL.b, colorTL.a,    0, 0, 1 }, -- 1  Top left
        {   right,     top, 0,    1, 1,    colorTR.r, colorTR.g, colorTR.b, colorTR.a,    0, 0, 1 }, -- 2  Top right
        {   right,  bottom, 0,    1, 0,    colorBL.r, colorBL.g, colorBL.b, colorBL.a,    0, 0, 1 }, -- 3  Bottom right
        {    left,  bottom, 0,    0, 0,    colorBR.r, colorBR.g, colorBR.b, colorBR.a,    0, 0, 1 }, -- 4  Bottom left
    }
	
	local attr1 = { "VertexPosition", "float", 3 }
	local attr2 = { "VertexTexCoord", "float", 2 }
	local attr3 = { "VertexColor", "byte", 4 }
	local attr4 = { "VertexNormal", "float", 3 }
	
	local meshLove = love.graphics.newMesh({ attr1, attr2, attr3, attr4 }, vertices, "triangles", "dynamic")
	--meshLove = love.graphics.newMesh(vertices)
	
	meshLove:setVertexMap(1, 2, 4,    2, 3, 4)
	meshLove:setDrawMode("triangles")
	
	return meshLove

end

-- Create a triangles

function createMeshTriangles(posTable, indexTable, colorTable)

	local vertices = {}
	local cDef = color(1, 1, 1, 1)
	
	for i = 1, #posTable do
	
		local p = posTable[i]
		local c = cDef
		
		if colorTable and #colorTable >= i then c = colorTable[i] end
	
		--   		       Pos XYZ      UV (ignore)       Color RGBA	     Normal XYZ
		vertices[i] = { p.x, p.y, p.z,    0, 0,      c.r, c.g, c.b, c.a,     0, 0, 1 }
	
	end
	
	local attr1 = { "VertexPosition", "float", 3 }
	local attr2 = { "VertexTexCoord", "float", 2 }
	local attr3 = { "VertexColor", "byte", 4 }
	local attr4 = { "VertexNormal", "float", 3 }
	
	local meshLove = love.graphics.newMesh({ attr1, attr2, attr3, attr4 }, vertices, "triangles", "dynamic")
	
	meshLove:setVertexMap(indexTable)
	meshLove:setDrawMode("triangles")
	
	return meshLove

end

-- Create from fbx file (make sure the mesh has been TRIANGULATED and has been built along XY coordinates)

function createMeshFbx(filename, meshName)

	local fbx = loadFbx(globalScenePath .. filename)
	
	if fbx ~= nil then
		
		local mesh = fbx.meshes[1]	
		
		-- If a specific mesh within the fbx is requested, see if it exists
	
		if meshName ~= nil then 
		
			for i = 1, fbx.meshCount do
			
				if fbx.meshes[i].name == meshName then 
				
					mesh = fbx.meshes[i]
				
				end
			
			end
		
		end
		
		-- If a valid mesh exists within the fbx, transfer its data to a new Love2D mesh
		
		if mesh then
		
			local vertices = {}
			local normals = {}
			
			-- Build normals using cross products from each triangle averaged together
			
			local index = 1
			
			for i = 1, #mesh.vertsX do normals[i] = vector(0, 0, 0) end
			
			while index < #mesh.indices do
			
				local i1 = mesh.indices[index    ]
				local i2 = mesh.indices[index + 1]
				local i3 = mesh.indices[index + 2]
			
				local v1 = vector(mesh.vertsX[i1], mesh.vertsY[i1], mesh.vertsZ[i1])
				local v2 = vector(mesh.vertsX[i2], mesh.vertsY[i2], mesh.vertsZ[i2])
				local v3 = vector(mesh.vertsX[i3], mesh.vertsY[i3], mesh.vertsZ[i3])
				
				local dir3v2 = vectorSubtract(v3, v2)
				local dir2v1 = vectorSubtract(v2, v1)
				
				local crossProduct = vectorCross(dir3v2, dir2v1)
				
				crossProduct:normalize()
			
				normals[i1]:add(crossProduct)
				normals[i2]:add(crossProduct)
				normals[i3]:add(crossProduct)
				
				index = index + 3
			
			end
			
			for i = 1, #mesh.vertsX do normals[i]:normalize() end
			
			local m = mesh
			
			for i = 1, #mesh.vertsX do
			
				--print("vertex", i, m.u[i], m.v[i])
			
				vertices[i] = { m.vertsX[i], m.vertsY[i], m.vertsZ[i], m.u[i], m.v[i], m.colors[i].r, m.colors[i].g, m.colors[i].b, m.colors[i].a, normals[i].x, normals[i].y, normals[i].z }
				
			end
			
			-- Create a Love2D mesh with a CUSTOM vertex definition.
			--
			-- This vertex will be almost identical to the default Love2D vertex, only the position
			-- attribute will be a vec3, instead of a vec2, because we're adding the z dimension. 
			-- It's also important to know that the attribute names ("VertexPosition", etc.) remain
			-- the same as Love2D's default names.
			
			local attr1 = { "VertexPosition", "float", 3 }
			local attr2 = { "VertexTexCoord", "float", 2 }
			local attr3 = { "VertexColor", "byte", 4 }
			local attr4 = { "VertexNormal", "float", 3 }
			
			meshLove = love.graphics.newMesh({ attr1, attr2, attr3, attr4 }, vertices, "triangles", "dynamic")
			--meshLove = love.graphics.newMesh(vertices)
			
			meshLove:setVertexMap(mesh.indices)
			meshLove:setDrawMode("triangles")
			
			return meshLove
			
		end
		
	end
	
	return nil

end