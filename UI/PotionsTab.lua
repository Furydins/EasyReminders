EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.PotionsTab = EasyReminders.UI.PotionsTab or {}

local PotionsTab = EasyReminders.UI.PotionsTab
local dataCache = {}

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

    ---
    local potionName = EasyReminders.AceGUI:Create("Label")
    potionName:SetText(itemName or "Loading...")
    potionName:SetFont(EasyReminders.Font, 12, "")
    potionName:SetWidth(250)
    potionName:SetImage(itemIcon)
    potionName:SetImageSize(16,16)
    scrollBox:AddChild(potionName)

    --
    local buffName = EasyReminders.AceGUI:Create("Label")
    buffName:SetText((spellInfo and spellInfo.name) or "Loading...")
    buffName:SetFont(EasyReminders.Font, 12, "")
    buffName:SetWidth(250)
    buffName:SetImage((spellInfo and spellInfo.iconID) or nil)
    buffName:SetImageSize(16,16)
    scrollBox:AddChild(buffName)

    dataCache[data.itemID] = {data.buffID, itemName, itemIcon, spellInfo, potionName, buffName}

    local raid = EasyReminders.AceGUI:Create("CheckBox")
    raid:SetType("checkbox")
    raid:SetValue(false)
    raid:SetWidth(75)
    raid:SetValue((EasyReminders.charDB.potions[data.itemID] and EasyReminders.charDB.potions[data.itemID].raid) or false)
    scrollBox:AddChild(raid)
    raid:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.potions[data.itemID] = EasyReminders.charDB.potions[data.itemID] or {}
      EasyReminders.charDB.potions[data.itemID].raid = value
    end)

    local dungeon = EasyReminders.AceGUI:Create("CheckBox")
    dungeon:SetType("checkbox")
    dungeon:SetValue(false)
    dungeon:SetWidth(75)
    dungeon:SetValue((EasyReminders.charDB.potions[data.itemID] and EasyReminders.charDB.potions[data.itemID].dungeon) or false)
    dungeon:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.potions[data.itemID] = EasyReminders.charDB.potions[data.itemID] or {}
      EasyReminders.charDB.potions[data.itemID].dungeon = value
    end)
    scrollBox:AddChild(dungeon)

    local outside = EasyReminders.AceGUI:Create("CheckBox")
    outside:SetType("checkbox")
    outside:SetValue(false)
    outside:SetWidth(75)
    outside:SetValue((EasyReminders.charDB.potions[data.itemID] and EasyReminders.charDB.potions[data.itemID].outside) or false)
    outside:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.potions[data.itemID] = EasyReminders.charDB.potions[data.itemID] or {}
      EasyReminders.charDB.potions[data.itemID].outside = value
    end)
    scrollBox:AddChild(outside)

  end
end

function PotionsTab:RefreshData()
  for itemID, data in pairs(dataCache) do
    local itemName = data[2] or C_Item.GetItemNameByID(itemID)
    local itemIcon = data[3] or C_Item.GetItemIconByID(itemID)
    local spellInfo = data[4] or C_Spell.GetSpellInfo(itemID)
    local potionName = data[5]
    local buffName = data[6]

    potionName:SetText(itemName or "Loading...")
    potionName:SetImage(itemIcon)

    buffName:SetText((spellInfo and spellInfo.name) or "Loading...")
    buffName:SetImage((spellInfo and spellInfo.iconID) or nil)

    dataCache[itemID] = {data[1], itemName, itemIcon, spellInfo, potionName, buffName}
  end
end




