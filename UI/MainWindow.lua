EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.MainWindow = EasyReminders.UI.MainWindow or {}

local MainWindow = EasyReminders.UI.MainWindow

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


-- Callback function for OnGroupSelected
local function SelectGroup(container, event, group)
   container:ReleaseChildren()
   if group == "tab1" then
      EasyReminders.UI.PotionsTab:Create(container)
    elseif group == "tab2" then
      EasyReminders.UI.BuffsTab:Create(container)
    elseif group == "tab3" then
      EasyReminders.UI.OptionsTab:Create(container)
   end
end

function MainWindow:CreateMainWindow()
    local mainFrame = EasyReminders.AceGUI:Create("Frame")
    mainFrame:SetWidth(800)
    mainFrame:SetHeight(600)
    mainFrame:SetTitle(L["Easy Reminders"])
    mainFrame:SetLayout("Fill")
    mainFrame:EnableResize(false)

    setCloseOnEscPress(mainFrame)

    -- Create the TabGroup
    local tab = EasyReminders.AceGUI:Create("TabGroup")
    tab:SetLayout("Flow")
    -- Setup which tabs to show
    tab:SetTabs({{text=L["Consumables"], value="tab1"}, {text=L["Raid Buffs"], value="tab2"}, {text=L["Options"], value="tab3"}})
    -- Register callback
    tab:SetCallback("OnGroupSelected", SelectGroup)
    -- Set initial Tab (this will fire the OnGroupSelected callback)
    tab:SelectTab("tab1")

    -- add to the frame container
    mainFrame:AddChild(tab)

    return mainFrame

end

