EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.OthersTab = EasyReminders.UI.OthersTab or {}

local OthersTab = EasyReminders.UI.OthersTab

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")


-- function that draws the widgets for the first tab
function OthersTab:Create(mainFrame, container)

  local titleContainer = EasyReminders.AceGUI:Create("SimpleGroup")
  titleContainer:SetFullWidth(true)
  titleContainer:SetLayout("Flow")  
  container:AddChild(titleContainer) 

  local rerollKey = EasyReminders.AceGUI:Create("CheckBox")
  rerollKey:SetValue(EasyReminders.charDB.rerollKey)
  rerollKey:SetType("checkbox")
  rerollKey:SetLabel(L["Reminder to Reroll Key on Mythic+ Dungeon Completion"])
  rerollKey:SetCallback("OnValueChanged", function(_,_,value)
    EasyReminders.charDB.rerollKey = value
  end)
  rerollKey:SetFullWidth(true)
  titleContainer:AddChild(rerollKey)

end










