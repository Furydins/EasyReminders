EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.ConsumablesDialog = EasyReminders.UI.ConsumablesDialog or {}

local ConsumablesDialog = EasyReminders.UI.ConsumablesDialog

local L = LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

local function setCloseOnEscPress(window)
   local oldCloseSpecialWindows = CloseSpecialWindows
    CloseSpecialWindows = function()
		if window:IsShown() then
			window:Hide()
			return true
		end

		return oldCloseSpecialWindows()
	end
end

function ConsumablesDialog:Create(mainFrame)
    local dialogFrame = EasyReminders.AceGUI:Create("Window")
    dialogFrame:SetWidth(600)
    dialogFrame:SetHeight(500)
    dialogFrame:SetTitle(L["Add Consumable"])
    dialogFrame:SetLayout("Flow")
    dialogFrame:EnableResize(false)
    dialogFrame.frame:SetFrameStrata("DIALOG")
    dialogFrame.frame:Raise()

    setCloseOnEscPress(dialogFrame)

    local addItemButton = EasyReminders.AceGUI:Create("Button")
    dialogFrame:AddChild(addItemButton)
    addItemButton:SetText("Add Item")
    addItemButton:SetCallback("OnClick", function(widget) EasyReminders.Print("adding...") end)

    return mainFrame

end