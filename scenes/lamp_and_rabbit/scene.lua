
 -- Setup scene

meshBg = createMeshFbx("meshes/bg.fbx")
meshGround = createMeshFbx("meshes/ground.fbx")
meshGlow = createMeshFbx("meshes/glow.fbx")
meshLamp1 = createMeshFbx("meshes/lamp_1.fbx")
meshLamp2 = createMeshFbx("meshes/lamp_2.fbx")
meshLamp3 = createMeshFbx("meshes/lamp_3.fbx")
meshLamp4 = createMeshFbx("meshes/lamp_4.fbx")
meshKnob = createMeshFbx("meshes/knob.fbx")
meshReflections = createMeshFbx("meshes/reflections.fbx")
meshRabbitShadow = createMeshFbx("meshes/rabbit_shadow.fbx")
meshRabbit1 = createMeshFbx("meshes/rabbit_1.fbx")
meshRabbit2 = createMeshFbx("meshes/rabbit_2.fbx")
meshFrame = createMeshFbx("meshes/frame.fbx")

local x = 0
local y = 2

createObjectShape(meshBg, vector(x, y))
createObjectShape(meshGround, vector(x, y))
createObjectShape(meshGlow, vector(x, y))
createObjectShape(meshLamp1, vector(x, y))
createObjectShape(meshLamp2, vector(x, y))
createObjectShape(meshLamp3, vector(x, y))
createObjectShape(meshLamp4, vector(x, y))
createObjectShape(meshKnob, vector(x, y))
createObjectShape(meshReflections, vector(x, y))
createObjectShape(meshRabbitShadow, vector(x, y))
createObjectShape(meshRabbit1, vector(x, y))
createObjectShape(meshRabbit2, vector(x, y))
createObjectShape(meshFrame, vector(x, y))