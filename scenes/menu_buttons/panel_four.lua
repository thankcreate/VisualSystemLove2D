-- Setup panel

function createPanelFour(vecPosition, vecExtents, menu)

	local colorPanel = color(1, 1, 1, 1)
	local panelMesh = createMeshRectangle(-vecExtents.x, vecExtents.x, -vecExtents.y, vecExtents.y, GREY, GREY, GREY, GREY)
	local panelRoot = createObjectShape(panelMesh, vecPosition, menu)
	
	radioTable = {} -- The table each radio group will add itself to + hold onto

	local radioGroup1 = createCustomRadioButtonGroup("RADIO 1", vector(-5,  5), radioTable, panelRoot, menu)
	local radioGroup2 = createCustomRadioButtonGroup("RADIO 2", vector(-5,  0), radioTable, panelRoot, menu)
	local radioGroup3 = createCustomRadioButtonGroup("RADIO 3", vector(-5, -5), radioTable, panelRoot, menu)
	
	function radioGroup1.button:switchOn() print("radio 1 on") end -- Override switch on/off functions
	function radioGroup1.button:switchOff() print("radio 1 off") end
	
	function radioGroup2.button:switchOn() print("radio 2 on") end -- Override switch on/off functions
	function radioGroup2.button:switchOff() print("radio 2 off") end
	
	function radioGroup3.button:switchOn() print("radio 3 on") end -- Override switch on/off functions
	function radioGroup3.button:switchOff() print("radio 3 off") end
	
	return panelRoot
	
end

-- Function for creating a group containing a button and text label

function createCustomRadioButtonGroup(name, vecPosition, radioTable, parent, menu)
	
	local baseRadius = 0.6
	local fillRadius = 0.4
	
	local baseMesh = createMeshCircle(40, baseRadius, GREY, GREY)
	
	local group = createObjectShape(baseMesh, vecPosition, parent) -- Group (parent of label and slider) + background circle
	local label = createObjectText(name, "left", "center", vector(8, 2), vector(10, 0, 0), group) -- Label
	local button = createObjectButton(nil, vector(fillRadius, fillRadius, 0), vector(0, 0, 0), group) -- Button
	
	label.textSize = 1.5
	
	group.color:set(0.3, 0.3, 0.3, 1)
	
	button.colorHover:set(0.8, 0.8, 0.8, 1)
	button.colorClick:set(0.3, 0.3, 0.3, 1)
	button.colorDefault:set(0.8, 0.8, 0.8, 1)
	button.color:copy(button.colorHover)
	
	button.extents:set(fillRadius + 2, fillRadius + 2) -- Resize the touch area
	button.mesh = createMeshCircle(40, fillRadius, GREY, GREY) -- Replace the button mesh
	button.isSwitchedOn = false
	button.radioTable = radioTable -- Button should hold onto the radio table
	
	function button:switchOn() end -- Override for custom switch ON functionality
	function button:switchOff() end -- Override for custom switch OFF functionality
	
	function button:action()
	
		if self.isSwitchedOn then -- Not switched on
		
			-- Already on, do nothing
			
		else 
		
			-- Find the radio button that's on and switch it off
			
			for i = 1, #self.radioTable do
				
				if self.radioTable[i].isSwitchedOn then
				
					self.radioTable[i].isSwitchedOn = false
					self.radioTable[i].canDrawSelf = false
					
					self.radioTable[i]:switchOff()
					
				end
			end
			
			-- Switch on this radio button
		
			self.isSwitchedOn = true
			self.canDrawSelf = true 
			
			self:switchOn()
			
		end
		
		
	end
	
	menu:addButton(button) -- Add this button to the menu
	
	group.button = button
	group.label = label
	
	radioTable[#radioTable + 1] = button -- Add the button to the radio table 
	
	if #radioTable == 1 then
		
		button.isSwitchedOn = true
		button.canDrawSelf = true 
	
	else -- Start switched off if not the first button in the radio table
		
		button.isSwitchedOn = false
		button.canDrawSelf = false 
		
	end
	
	return group
	
end