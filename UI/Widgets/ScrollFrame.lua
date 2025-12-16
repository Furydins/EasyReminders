EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.Widgets = EasyReminders.UI.Widgets or {}

EasyReminders.UI.Widgets.ScrollFrame = EasyReminders.UI.Widgets.ScrollFrame or {}

local ScrollFrame = EasyReminders.UI.Widgets.ScrollFrame


function ScrollFrame:Create(parent)

	EasyReminders:Print("Creating Scroll Frame")

	local scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetFullHeight(true)
	scrollcontainer:SetLayout("Fill")

	parent:AddChild(scrollcontainer)

	scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scrollcontainer:AddChild(scroll)

	-- Some fake test data

	local myData = {
    PlayerName = "Ghost",
    PlayerClass = "Priest"
	}

	local button = EasyReminders.AceGUI:Create("Button")
	button:SetText(myData.PlayerName)
	button:SetWidth(200)
	scroll:AddChild(button)
	button:SetScript("OnClick", function()
        	EasyReminders:Print(playerName .. ": " .. playerClass)
    	end)

	return scroll

end

