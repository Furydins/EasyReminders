EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.BuffsTab = EasyReminders.UI.BuffsTab or {}

local BuffsTab = EasyReminders.UI.BuffsTab

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

-- function that draws the widgets for the first tab
function BuffsTab:Create(container)
  local desc = EasyReminders.AceGUI:Create("Label")
  desc:SetText(L["Buffs"])
  desc:SetFullWidth(true)
  container:AddChild(desc)
  
  local button = EasyReminders.AceGUI:Create("Button")
  button:SetText(L["Add Buff Reminder"])
  button:SetWidth(200)
  container:AddChild(button)
end
