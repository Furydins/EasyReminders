EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.PotionsTab = EasyReminders.UI.PotionsTab or {}

local PotionsTab = EasyReminders.UI.PotionsTab

local L = LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

-- function that draws the widgets for the first tab
function PotionsTab:Create(container)
  local desc = EasyReminders.AceGUI:Create("Label")
  desc:SetText(L["Potions"])
  desc:SetFullWidth(true)
  container:AddChild(desc)

  local button = EasyReminders.AceGUI:Create("Button")
  button:SetText(L["Add Potion Reminder"])
  button:SetWidth(200)
  container:AddChild(button)

  local listFrame =  EasyReminders.AceGUI:Create("Frame")
  listFrame:SetFullWidth(true)
  listFrame:SetHeight(300)
  container:AddChild(listFrame)
  
  local scrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(listFrame.frame)
end
