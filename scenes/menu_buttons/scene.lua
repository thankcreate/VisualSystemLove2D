require(globalScenePath .. 'panel_one')
require(globalScenePath .. 'panel_two')
require(globalScenePath .. 'panel_three')
require(globalScenePath .. 'panel_four')

-- Setup a scene

rootObject = createObject(vector(0, 0))

function rootObject:draw(camera) love.graphics.clear(0.95, 0.95, 0.95, 1.0) end

-- Create menu objects

cameraForMenu = globalCameraMain -- Create a new camera for the menu
--cameraForMenu = createObjectCamera(100, vector(0, 0, 50)) -- Or use the default lib camera

menu1 = createObjectMenu(cameraForMenu, rootObject)
menu2 = createObjectMenu(cameraForMenu, rootObject)
menu3 = createObjectMenu(cameraForMenu, rootObject)
menu4 = createObjectMenu(cameraForMenu, rootObject)

panelOneObject = createPanelOne(vector(-21,  17, 0), vector(20, 16, 0), menu1)
panelTwoObject = createPanelTwo(vector( 21,  17, 0), vector(20, 16, 0), menu2)
panelThreeObject = createPanelThree(vector(-21,  -17, 0), vector(20, 16, 0), menu3)
panelFourObject = createPanelFour(vector( 21,  -17, 0), vector(20, 16, 0), menu4)
