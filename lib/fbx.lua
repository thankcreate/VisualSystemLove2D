require 'lib/color'

fbxList = {} 
fbxCount = 0

----------------------------------------------------------------------------------------------------------------
-- This importer works with files exported using the "2010" FBX format. It will not work with later versions! --
------------------- Make sure to TRIANGULATE and APPLY VERTEX COLORS to exported meshes ------------------------
----------------------------------------------------------------------------------------------------------------
function loadFbx(filename)
	
	-- Check to see if this file has already been opened
	
	for i = 1, fbxCount do
	
		if fbxList[i].name == filename then
		
			print("Load fbx - Returning found mesh: " .. filename)
			
			return fbxList[i]
			
		end
	
	end
	
	-- Check to see if this file exists
	
	if love.filesystem.getInfo(filename) == nil then 
	
		print("Load fbx - File doesn't exist: " .. filename)
		
		return nil 
		
	end
	
	-- Create fbx, add it to the list, and read file

	fbx = { name = filename, meshCount = 0, meshes = nil }

	fbx.meshes = { }
	
	fbxCount = fbxCount + 1

	fbxList[fbxCount] = fbx
	
	print("Load fbx - Opening filename: " .. filename)

	local getLine = love.filesystem.lines(filename)
	
	local line

	repeat 
	
		line = getLine() 
		
	until line == "Objects:  {"

	repeat
	
		line = getLine()
		
		local mesh_name = line:match('Model: "(.-)", "Mesh" {')
		
		if mesh_name then
		
			mesh_name = string.gsub(mesh_name, "Model::", "")
		
			print("Load fbx - Found mesh: " .. mesh_name)

			local mesh = { name = mesh_name, vertsX = {}, vertsY = {}, vertsZ = {}, u = {}, v = {}, indices = {}, colors = {} }
			local doneWithMesh = false
			local foundColorSet = false

			repeat
			
				linePrev3 = linePrev2
				linePrev2 = linePrev1
				linePrev1 = line
			
				line = getLine()
				
				if line == "}" then 
				
					print("Does this mesh have vertex colors applied to it?")
					--print("SO WHAT: " .. line .. " " .. linePrev1 .. " " .. linePrev2 .. " " .. linePrev3) 
					
				end 
				
				local l = line:match("Vertices: (.*)")
				
				-- FOUND: Start of VERTEX and TRIANGLE information
				
				if l then
				
					--print("l: " .. l)
				
					-- Collect all of the position values into a long string
					
					local lineEnd = nil
				
					while true do
					
						line = getLine()
						
						lineEnd = line:match("PolygonVertexIndex: (.*)")
						
						if lineEnd then
						
							break
							
						else
						
							local ll = line:match("(,.*)")
							
							if ll then
							
								l = l .. ll
								
								--print("ll1: " .. ll)
								
							end
							
						end
						
					end
					
					-- Separate string of position values into vectors (XYZ, though Z will be ignored)
					
					local vertCount = 0

					for x, y, z in l:gfind("([^,]+),([^,]+),([^,]+)") do
					
						vertCount = vertCount + 1
						
						mesh.vertsX[vertCount] = tonumber(x)
						mesh.vertsY[vertCount] = tonumber(y)
						mesh.vertsZ[vertCount] = tonumber(z)
						
					end
					
					print("Load fbx - Vertex count: " .. vertCount)
				
					-- Collect all of the polygon index values
					
					l = lineEnd
					
					while true do
					
						line = getLine()
						
						--lineEnd = line:match("GeometryVersion: (.*)")
						lineEnd = line:match("(.*): (.*)")
						
						if lineEnd then
						
							break
							
						else
						
							local ll = line:match("(,.*)")
							
							if ll then
							
								l = l .. ll
								
								--print("ll2: " .. ll)
								
							end
							
						end
						
					end
					
					local indexCount = 0
					
					for i in l:gfind("[^,]+") do
					
						i = tonumber(i)
						
						if i < 0 then
						
							i = -i - 1
							
							--print("i: " .. i)
							
						end
						
						indexCount = indexCount + 1
						
						mesh.indices[indexCount] = i + 1
						
						--print("found index:", i + 1)
						
					end
					
					print("Load fbx - Mesh triangle count: " .. indexCount / 3)
					
				end
				
				local l = line:match("Colors: (.*)")
				
				-- FOUND: Start of COLOR information
				
				if l and foundColorSet == false then
				
					foundColorSet = true
				
					-- Collect all of the color values into a long string
					
					local lineEnd = nil
				
					while true do
					
						line = getLine()
						
						lineEnd = line:match("ColorIndex: (.*)")
						
						if lineEnd then
							
							break
							
						else
						
							local ll = line:match("(,.*)")
							
							if ll then
							
								l = l .. ll
								
							end
							
						end
						
					end
					
					-- Separate string of color values into 4 component colors (RGBA)
					
					local colorCount = 0
					
					colors =  {}

					for r, g, b, a in l:gfind("([^,]+),([^,]+),([^,]+),([^,]+)") do
					
						colorCount = colorCount + 1
						
						local cR = tonumber(r)
						local cG = tonumber(g)
						local cB = tonumber(b)
						local cA = tonumber(a)
						
						colors[colorCount] = color(cR, cG, cB, cA)
						
						--print(cR, cG, cB, cA)
						
					end
					
					print("Load fbx - Mesh color count: " .. colorCount)
				
					-- Collect all of the color index values
					
					for i = 1, colorCount / 3 do
					
						local n = (i - 1) * 3
						
						mesh.colors[mesh.indices[n + 1]] = colors[n + 1]
						mesh.colors[mesh.indices[n + 2]] = colors[n + 2]
						mesh.colors[mesh.indices[n + 3]] = colors[n + 3]
						
						--print("color indices", n + 1, n + 2, n + 3)
					
					end
					
				end
				
				local l = line:match("UV: (.*)")
				--local l = line:match(" UV: (.*)") -- Include space before "UV:"
				
				-- FOUND: Start of VERTEX and TRIANGLE information
				
				if l then
				
					local lB = line:match("LayerElementUV:")
					
					if lB == nil then
					
						--print("l: " .. l)
					
						-- Collect all of the position values into a long string
						
						local lineEnd = nil
					
						while true do
						
							line = getLine()
							
							lineEnd = line:match("UVIndex: (.*)")
							
							if lineEnd then
							
								break
								
							else
							
								local ll = line:match("(,.*)")
								
								if ll then
								
									l = l .. ll
									
									--print("ll1: " .. ll)
									
								end
								
							end
							
						end
						
						-- Separate string of position values into vectors (XYZ, though Z will be ignored)
						
						local uvCount = 0

						for u, v in l:gfind("([^,]+),([^,]+)") do
						
							uvCount = uvCount + 1
							
							mesh.u[uvCount] = tonumber(u)
							mesh.v[uvCount] = tonumber(v)
							
							--print(mesh.u[uvCount], mesh.v[uvCount])
							
						end
						
						print("Load fbx - UV count: " .. uvCount)
					
						-- Collect all of the polygon index values
						
						l = lineEnd
						
						while true do
						
							line = getLine()
							
							--lineEnd = line:match("GeometryVersion: (.*)")
							lineEnd = line:match("(.*): (.*)")
							
							if lineEnd then
							
								break
								
							else
							
								local ll = line:match("(,.*)")
								
								if ll then
								
									l = l .. ll
									
									--print("ll2: " .. ll)
									
								end
								
							end
							
						end
						
						local uvIndexCount = 0
						
						for i in l:gfind("[^,]+") do
						
							i = tonumber(i)
							
							if i < 0 then
							
								i = -i - 1
								
								--print("i: " .. i)
								
							end
							
							uvIndexCount = uvIndexCount + 1
							
							--mesh.indices[uvIndexCount] = i + 1
							
							--print("found index:", i + 1)
							
						end
						
						--print("Load fbx - UV index count: " .. uvIndexCount)
						
						doneWithMesh = true
						
					end
					
				end
				
			until doneWithMesh == true

			fbx.meshCount = fbx.meshCount + 1
			
			fbx.meshes[fbx.meshCount] = mesh
			
		end

	until line == "}"

	return fbx
	
end
