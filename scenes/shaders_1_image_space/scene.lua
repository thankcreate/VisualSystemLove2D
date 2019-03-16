
-- Create a new shader

shaderDirect = createShader("shaders/v_direct.vert", "shaders/f_direct.frag")

function shaderDirect:updateUniforms()

	-- Normally you would have some sort of data (transform, time, screen size, etc.) that
	-- would need to be sent to the shader here.

end

-- Create an object that will draw a triangle

local vertices = { vector(0, -1.0), vector(-1.0, 1.0), vector(1.0, 1.0) }
local indices = { 1, 2, 3 }
local colors = { RED, BLUE, GREEN }

mesh = createMeshTriangles(vertices, indices, colors)
object = createObjectShape(mesh, vector(0, 0), nil)

object.shader = shaderDirect -- Assign the new shader to object
