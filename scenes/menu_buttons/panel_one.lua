-- Setup panel

function createPanelOne(vecPosition, vecExtents, menu)

	local colorPanel = color(1, 1, 1, 1)
	local panelMesh = createMeshRectangle(-vecExtents.x, vecExtents.x, -vecExtents.y, vecExtents.y, GREY, GREY, GREY, GREY)
	local panelRoot = createObjectShape(panelMesh, vecPosition, menu)

	local startY = 10
	local spaceY = 5

	local sliderGroup1 = createCustomSliderGroup("VALUE 1", 0.0,  1.0, vector(-0, startY - (spaceY * 0)), panelRoot, menu)
	local sliderGroup2 = createCustomSliderGroup("VALUE 2", 0.1, 10.0, vector(-0, startY - (spaceY * 1)), panelRoot, menu)
	local sliderGroup3 = createCustomSliderGroup("VALUE 3", 0.0,  1.0, vector(-0, startY - (spaceY * 2)), panelRoot, menu)
	local sliderGroup4 = createCustomSliderGroup("VALUE 4", 0.1, 10.0, vector(-0, startY - (spaceY * 3)), panelRoot, menu)
	local sliderGroup5 = createCustomSliderGroup("VALUE 5", 0.1, 10.0, vector(-0, startY - (spaceY * 4)), panelRoot, menu)

	function sliderGroup1.slider:updateValue(value) 

		print(value) 

	end
	
	return panelRoot
	
end

-- Function for creating a group containing a slider and label

function createCustomSliderGroup(name, valMin, valMax, vecPosition, parent, menu)
	
	local width = 16
	local handleExtX = 1.2
	local handleExtY = 1.2
	local barExtX = (width / 2) + handleExtX - 0.25
	local barExtY = 0.1
	
	local group = createObject(vecPosition, parent) -- Group (parent of label and slider)
	local label = createObjectText(name, "left", "center", vector(barExtX, 2), vector(0, 1.5, 0), group) -- Label
	local slider = createObjectButtonSlider(vector(0, 0, 0), width, valMin, valMax, group) -- Slider
	
	label.textSize = 1.5
	
	slider:setHandleMesh(createMeshRectangle(-handleExtX, handleExtX, -handleExtY, handleExtY, GREY, GREY, GREY, GREY))
	slider:setHandleColor(color(0.8, 0.8, 0.8, 1))
	slider:setHandleTexture(createTexture("images/handle_1.png", true))
	
	slider.colorHover:set(1, 0.7, 0.8, 1)
	slider.colorClick:set(1, 0.6, 0.7, 1)
	
	slider:setBarMesh(createMeshRectangle(-barExtX, barExtX, -barExtY, barExtY, GREY, GREY, GREY, GREY))
	slider:setBarColor(color(0.3, 0.3, 0.3, 1))

	menu:addButton(slider) -- Add this button to the menu
	
	group.label = label
	group.slider = slider
	
	return group
	
end