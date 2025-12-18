EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.PotionsTab = EasyReminders.UI.PotionsTab or {}

local PotionsTab = EasyReminders.UI.PotionsTab

local L = LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

-- function that draws the widgets for the first tab
function PotionsTab:Create(container)

  local titleContainer = EasyReminders.AceGUI:Create("SimpleGroup")
  titleContainer:SetFullWidth(true)
  titleContainer:SetLayout("Flow")  
  container:AddChild(titleContainer)

  local spacer  = EasyReminders.AceGUI:Create("Label")
  spacer:SetText("")
  spacer:SetWidth(10)
  titleContainer:AddChild(spacer)

  local potionTitle = EasyReminders.AceGUI:Create("Label")
  potionTitle:SetText("Item")
  potionTitle:SetWidth(250)
  titleContainer:AddChild(potionTitle)

  --
  local buffTitle = EasyReminders.AceGUI:Create("Label")
  buffTitle:SetText("Tracked Buff")
  buffTitle:SetWidth(250)
  titleContainer:AddChild(buffTitle)

  local raidTitle = EasyReminders.AceGUI:Create("Label")
  raidTitle:SetText("Raid")
  raidTitle:SetWidth(75)
  titleContainer:AddChild(raidTitle)

  local dungeonTitle = EasyReminders.AceGUI:Create("Label")
  dungeonTitle:SetText("Dungeon")
  dungeonTitle:SetWidth(75)
  titleContainer:AddChild(dungeonTitle)

  local outsideTitle = EasyReminders.AceGUI:Create("Label")
  outsideTitle:SetText("Outside")
  outsideTitle:SetWidth(75)
  titleContainer:AddChild(outsideTitle)

  
  local scrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)

  for key, data in pairs(EasyReminders.Data.Consumables)  do


    local itemName = C_Item.GetItemNameByID(data.itemID)
    local itemIcon = C_Item.GetItemIconByID(data.itemID)
    local spellInfo = C_Spell.GetSpellInfo(data.buffID)

    if itemName and itemIcon and spellInfo then
      ---
      local potionName = EasyReminders.AceGUI:Create("Label")
      potionName:SetText(itemName)
      potionName:SetFont(EasyReminders.Font, 12, "")
      potionName:SetWidth(250)
      potionName:SetImage(itemIcon)
      potionName:SetImageSize(16,16)
      scrollBox:AddChild(potionName)

      --
      local buffName = EasyReminders.AceGUI:Create("Label")
      buffName:SetText(spellInfo.name)
      buffName:SetFont(EasyReminders.Font, 12, "")
      buffName:SetWidth(250)
      buffName:SetImage(spellInfo.iconID)
      buffName:SetImageSize(16,16)
      scrollBox:AddChild(buffName)

      local raid = EasyReminders.AceGUI:Create("CheckBox")
      raid:SetType("checkbox")
      raid:SetValue(false)
      raid:SetWidth(75)
      scrollBox:AddChild(raid)

      local dungeon = EasyReminders.AceGUI:Create("CheckBox")
      dungeon:SetType("checkbox")
      dungeon:SetValue(false)
      dungeon:SetWidth(75)
      scrollBox:AddChild(dungeon)

      local outside = EasyReminders.AceGUI:Create("CheckBox")
      outside:SetType("checkbox")
      outside:SetValue(false)
      outside:SetWidth(75)
      scrollBox:AddChild(outside)
    else
      EasyReminders.Print("Missing data for itemID:", data.itemID, "name: ", itemName, "icon:", itemIcon, "buff:", spellInfo)
    end
  end
end


