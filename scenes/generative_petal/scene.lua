
-- Setup a scene
 
generative_petal = {}
 
generative_petal.colorRand = color(1, 1, 1, 1)
	
-- Create morpher

meshPetalRuffle = createMeshFbx("meshes/petal_shapes.fbx", "ruffle") -- Shape targets...
meshPetalRound = createMeshFbx("meshes/petal_shapes.fbx", "round")
meshPetalSquash = createMeshFbx("meshes/petal_shapes.fbx", "squash")
meshPetalDent = createMeshFbx("meshes/petal_shapes.fbx", "dent")
meshPetalWiden = createMeshFbx("meshes/petal_shapes.fbx", "widen")
meshPetalExtend = createMeshFbx("meshes/petal_shapes.fbx", "extend")
meshPetalCrescent = createMeshFbx("meshes/petal_shapes.fbx", "crescent")

meshPetalColorCenter = createMeshFbx("meshes/petal_colors.fbx", "color_center") -- Color targets...
meshPetalColorRim = createMeshFbx("meshes/petal_colors.fbx", "color_rim")
meshPetalColorTip = createMeshFbx("meshes/petal_colors.fbx", "color_tip")
meshPetalColorRoot = createMeshFbx("meshes/petal_colors.fbx", "color_root")
meshPetalColorBelly = createMeshFbx("meshes/petal_colors.fbx", "color_belly")
meshPetalColorLinear = createMeshFbx("meshes/petal_colors.fbx", "color_linear")

targetsShape = { meshPetalRuffle, meshPetalRound, meshPetalSquash, meshPetalDent, meshPetalWiden, meshPetalExtend, meshPetalCrescent }
namesShape = { "RUFFLE", "ROUND", "SQUASH", "DENT", "WIDEN", "EXTEND", "CESCENT" }
targetsColor = { meshPetalColorCenter, meshPetalColorRim, meshPetalColorTip, meshPetalColorRoot, meshPetalColorBelly, meshPetalColorLinear }
namesColor = { "CENTER", "RIM", "TIP", "ROOT", "BELLY", "LINEAR" }

indexShape = 1
indexColor = 1

local meshPetalBase = createMeshFbx("meshes/petal_shapes.fbx", "base") -- The mesh being distorted/colored

objectPetal = createObjectShape(meshPetalBase, vector(16, -24))

objectPetal.scale.x = 8
objectPetal.scale.y = 8

morpher1 = createMorpher(meshPetalBase)

-- Create menu

camera2 = createObjectCamera(100, vector(0, 0, 50)) -- Menu camera

menu1 = createObjectMenu(camera2)

local posY = 35

buttonShapeLabel = menu1:addButton(createObjectButton("---", vector(5, 2), vector(-42, posY)))
buttonShapePrev = menu1:addButton(createObjectButton("<", vector(3, 2), vector(-34, posY)))
buttonShapeNext = menu1:addButton(createObjectButton(">", vector(3, 2), vector(-28, posY)))
buttonShapeApply1 = menu1:addButton(createObjectButton("SUB", vector(3, 2), vector(-16, posY)))
buttonShapeApply2 = menu1:addButton(createObjectButton("ADD", vector(3, 2), vector(-22, posY)))

buttonShapeLabel.textChild.textSize = 1.5
buttonShapePrev.textChild.textSize = 1.5
buttonShapeNext.textChild.textSize = 1.5
buttonShapeApply1.textChild.textSize = 1.5
buttonShapeApply2.textChild.textSize = 1.5

function buttonShapeLabel:update(dt)

	self.textChild.text = namesShape[indexShape + 1]

	self:calculateMinMax()

end

function buttonShapeNext:action()

	indexShape = (indexShape + 1) % #targetsShape
	
	print("Shape target: " .. namesShape[indexShape + 1])
	
end

function buttonShapePrev:action()

	indexShape = (indexShape - 1) % #targetsShape
	
	print("Shape target: " .. namesShape[indexShape + 1])
	
end

function buttonShapeApply1:action()

	morpher1:blendXY(targetsShape[indexShape + 1], -0.2)
	morpher1:updateMesh()

end

function buttonShapeApply2:action()

	morpher1:blendXY(targetsShape[indexShape + 1], 0.2)
	morpher1:updateMesh()

end

posY = 30

buttonColorLabel = menu1:addButton(createObjectButton("---", vector(5, 2), vector(-42, posY) ))
buttonColorPrev = menu1:addButton(createObjectButton("<", vector(3, 2), vector(-34, posY)))
buttonColorNext = menu1:addButton(createObjectButton(">", vector(3, 2), vector(-28, posY)))
buttonColorApply2 = menu1:addButton(createObjectButton("ADD", vector(3, 2), vector(-22, posY)))

buttonColorLabel.textChild.textSize = 1.5
buttonColorPrev.textChild.textSize = 1.5
buttonColorNext.textChild.textSize = 1.5
buttonColorApply2.textChild.textSize = 1.5

function buttonColorLabel:update(dt)

	self.textChild.text = namesColor[indexColor + 1]

	self:calculateMinMax()

end

function buttonColorNext:action()

	indexColor = (indexColor + 1) % #targetsColor
	
	generative_petal.colorRand:set(math.random(), math.random(), math.random(), 1)
	
	print("Color target: " .. namesColor[indexColor + 1])
	
end

function buttonColorPrev:action()

	indexColor = (indexColor - 1) % #targetsColor
	
	generative_petal.colorRand:set(math.random(), math.random(), math.random(), 1)
	
	print("Color target: " .. namesColor[indexColor + 1])
	
end

function buttonColorApply2:action()

	morpher1:blendRGBA(targetsColor[indexColor + 1], generative_petal.colorRand, 0.2)
	morpher1:updateMesh()

end

buttonColorLabel.isClickable  = false
buttonColorLabel.color = color(0.3, 0.3, 0.3, 1)
buttonColorLabel.colorDefault = buttonColorLabel.color

buttonShapeLabel.isClickable  = false
buttonShapeLabel.color = color(0.3, 0.3, 0.3, 1)
buttonShapeLabel.colorDefault = buttonShapeLabel.color

for i = 1, 111 do -- Start with randomized color

	generative_petal.colorRand:set(math.random(), math.random(), math.random(), 1)
	
	morpher1:blendRGBA(targetsColor[(i % #targetsColor) + 1], generative_petal.colorRand, 0.3)
	
end

morpher1:updateMesh()
