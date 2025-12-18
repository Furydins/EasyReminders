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

	-- Some fake test data

	--local myData = {
    --PlayerName = "Ghost",
    --PlayerClass = "Priest"
	--}

	--for i=1,20 do

	--	local button = EasyReminders.AceGUI:Create("Button")
	--	button:SetText(myData.PlayerName .. tostring(i))
	--	button:SetFullWidth(true)
	--	scroll:AddChild(button)
	--	button:SetCallback("OnClick", function(this)
--				EasyReminders:Print(myData.PlayerName .. ": " .. tostring(i) .. " clicked!")
	--		end)

	--end

	return scroll

end

