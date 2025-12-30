EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.Widgets = EasyReminders.UI.Widgets or {}

EasyReminders.UI.Widgets.ScrollFrame = EasyReminders.UI.Widgets.ScrollFrame or {}

local ScrollFrame = EasyReminders.UI.Widgets.ScrollFrame
local AceGUI = EasyReminders.AceGUI


function ScrollFrame:Create(parent)
	local scrollcontainer = AceGUI:Create("InlineGroup") -- "InlineGroup" is also good
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetFullHeight(true)
	scrollcontainer:SetLayout("Fill")

	parent:AddChild(scrollcontainer)

	scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scrollcontainer:AddChild(scroll)
	
	return scroll

end

