kirbyLow = createMeshFbx("meshes/file_kirby50.fbx");
kirbyMiddle = createMeshFbx("meshes/file_kirby100.fbx");
kirbyHigh = createMeshFbx("meshes/file_kirby500.fbx");

haha = createMeshFbx("meshes/file_haha.fbx");


local x = 0
local y = 0

local scale = 8
local gap = 2;
local scaleVec = vector(scale, scale, 5)

x1 = x - 4 * scale - gap
local kirbyShapeLow = createObjectShape(kirbyLow, vector(x1, y))
kirbyShapeLow.scale = scaleVec


local kirbyShapeMiddle = createObjectShape(kirbyMiddle, vector(0, y))
kirbyShapeMiddle.scale = scaleVec

x3 = x + 4 * scale + gap
local kirbyShapeHigh = createObjectShape(kirbyHigh, vector(x3, y))
kirbyShapeHigh.scale = scaleVec

-- local hahaShape = createObjectShape(haha, vector(x3, y))
-- hahaShape.scale = scaleVec