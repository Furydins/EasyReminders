EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.OptionsTab = EasyReminders.UI.OptionsTab or {}

local OptionsTab = EasyReminders.UI.OptionsTab

local L = LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

-- function that draws the widgets for the first tab
function OptionsTab:Create(container)
  local desc = EasyReminders.AceGUI:Create("Label")
  desc:SetText(L["Options"])
  desc:SetFullWidth(true)
  container:AddChild(desc)

  local button = EasyReminders.AceGUI:Create("Button")
  button:SetText(L["Some Options"])
  button:SetWidth(200)
  container:AddChild(button)
end
