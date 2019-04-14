-- Setup panel

function createPanelThree(vecPosition, vecExtents, menu)

	local colorPanel = color(1, 1, 1, 1)
	local panelMesh = createMeshRectangle(-vecExtents.x, vecExtents.x, -vecExtents.y, vecExtents.y, GREY, GREY, GREY, GREY)
	local panelRoot = createObjectShape(panelMesh, vecPosition, menu)

	local button1 = createCustomButton("1", vector(-10, 0), panelRoot, menu)
	local button2 = createCustomButton("2", vector(  0, 0), panelRoot, menu)
	local button3 = createCustomButton("3", vector( 10, 0), panelRoot, menu)
		
	function button1:action()
	
		print("click 1")
		
	end	
	
	function button2:action()
	
		print("click 2")
		
	end	
	
	function button3:action()
	
		print("click 3")
		
	end
	
	
	return panelRoot
	
end

-- Function for creating a custom button (custom re. its presentation)

function createCustomButton(name, vecPosition, parent, menu)
	
	local radius = 3
	
	local button = createObjectButton(name, vector(radius, radius), vecPosition, parent) -- Button
	
	button.textChild.textSize = 3.5
	button.textChild.justifyX = "center"
	
	button.colorHover:set(0.2, 0.2, 0.2, 1)
	button.colorClick:set(0.3, 0.3, 0.3, 1)
	button.colorDefault:set(0.4, 0.4, 0.4, 1)
	button.color:copy(button.colorDefault)
	
	button.mesh = createMeshCircle(40, radius, WHITE, WHITE)
	
	button.extents:set(radius + 2, radius + 2) -- Resize the touch areas
	button.isTrue = true

	menu:addButton(button) -- Add this button to the menu
	
	return button
	
end