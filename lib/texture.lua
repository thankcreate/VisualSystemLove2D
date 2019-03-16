
function createTexture(path, generateMipmaps)

	local image = love.graphics.newImage(globalScenePath .. path, { mipmaps = generateMipmaps })
	
	return image

end
