EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.MainWindow = EasyReminders.UI.MainWindow or {}

local MainWindow = EasyReminders.UI.MainWindow

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

local mainFrame


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
      EasyReminders.UI.BuffTab:Create(mainFrame, container)
  elseif group == "tab2" then
      EasyReminders.UI.ConsumablesTab:Create(mainFrame, container)
      EasyReminders.UI.WellFedTab:Create(mainFrame, container)
   elseif group == "tab3" then
      EasyReminders.UI.WellFedTab:Create(mainFrame, container)
   elseif group == "tab4" then
      EasyReminders.UI.HolidayTab:Create(mainFrame, container)
   end
end

function MainWindow:CreateMainWindow()
    mainFrame = EasyReminders.AceGUI:Create("Window")
    mainFrame:SetWidth(800)
    mainFrame:SetHeight(600)
    mainFrame:SetTitle(L["Easy Reminders"])
    mainFrame:SetLayout("Fill")
    mainFrame:EnableResize(false)
    mainFrame.frame:SetFrameStrata("HIGH")
    mainFrame:Hide()

    setCloseOnEscPress(mainFrame)

    -- Create the TabGroup
    local tab = EasyReminders.AceGUI:Create("TabGroup")
    tab:SetLayout("Flow")
    -- Setup which tabs to show
    tab:SetTabs({ {text=L["Buffs"], value="tab1"}, {text=L["Consumables"], value="tab2"}, {text=L["Well Fed"], value="tab3"},
             {text=L["Holidays"], value = "tab4"}, })
    -- Register callback
    tab:SetCallback("OnGroupSelected", SelectGroup)
    -- Set initial Tab (this will fire the OnGroupSelected callback)
    tab:SelectTab("tab1")

    -- add to the frame container
    mainFrame:AddChild(tab)
    

    return mainFrame

end

