-- Setup panel

function createPanelTwo(vecPosition, vecExtents, menu)

	local colorPanel = color(1, 1, 1, 1)
	local panelMesh = createMeshRectangle(-vecExtents.x, vecExtents.x, -vecExtents.y, vecExtents.y, GREY, GREY, GREY, GREY)
	local panelRoot = createObjectShape(panelMesh, vecPosition, menu)

	local boolGroup1 = createCustomBooleanGroup("BOOL 1", vector(-10,  8), panelRoot, menu)
	local boolGroup2 = createCustomBooleanGroup("BOOL 2", vector( 10,  8), panelRoot, menu)
	local boolGroup3 = createCustomBooleanGroup("BOOL 3", vector(-10, -10), panelRoot, menu)
	local boolGroup4 = createCustomBooleanGroup("BOOL 4", vector( 10, -10), panelRoot, menu)
	
	function boolGroup1.button:switched()
	
		print("bool group 1: ", self.isSwitchedOn)
	
	end
	
	function boolGroup2.button:switched()
	
		print("bool group 2: ", self.isSwitchedOn)
	
	end
	
	function boolGroup3.button:switched()
	
		print("bool group 3: ", self.isSwitchedOn)
	
	end
	
	function boolGroup4.button:switched()
	
		print("bool group 4: ", self.isSwitchedOn)
	
	end
	
	return panelRoot
	
end

-- Function for creating a group containing a button and text label

function createCustomBooleanGroup(name, vecPosition, parent, menu)
	
	local baseExtX = 0.6
	local baseExtY = 0.6
	local fillExtX = 0.4
	local fillExtY = 0.4
	
	local baseMesh = createMeshRectangle(-baseExtX, baseExtX, -baseExtY, baseExtY, GREY, GREY, GREY, GREY)
	
	local group = createObjectShape(baseMesh, vecPosition, parent) -- Group (parent of label and slider) + background square
	local label = createObjectText(name, "center", "center", vector(8, 2), vector(0, 1.9, 0), group) -- Label
	local button = createObjectButton(nil, vector(fillExtX, fillExtY, 0), vector(0, 0, 0), group) -- Button
	
	label.textSize = 1.5
	
	group.color:set(0.3, 0.3, 0.3, 1)
	
	button.extents:set(fillExtX + 2, fillExtY + 2) -- Resize the touch area
	button.isSwitchedOn = true
	
	function button:switched() end -- Override for custom switch functionality
	
	function button:action()
	
		if self.isSwitchedOn then 
		
			self.isSwitchedOn = false 
			self.canDrawSelf  = false
			
		else
		
			self.isSwitchedOn = true
			self.canDrawSelf = true 
			
		end
		
		self:switched()
		
	end
	
	menu:addButton(button) -- Add this button to the menu
	
	group.label = label
	group.button = button
	
	return group
	
end