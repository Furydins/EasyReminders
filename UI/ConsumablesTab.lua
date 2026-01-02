EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.ConsumablesTab = EasyReminders.UI.ConsumablesTab or {}

local ConsumablesTab = EasyReminders.UI.ConsumablesTab

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

-- function that draws the widgets for the first tab
function ConsumablesTab:Create(mainFrame, container)

  local addItemButton = EasyReminders.AceGUI:Create("Button")
  container:AddChild(addItemButton)
  addItemButton:SetText(L["Add Item"])
  addItemButton:SetCallback("OnClick", function(widget) EasyReminders.UI.ConsumablesDialog:Create(mainFrame) end)

  local titleContainer = EasyReminders.AceGUI:Create("SimpleGroup")
  titleContainer:SetFullWidth(true)
  titleContainer:SetLayout("Flow")  
  container:AddChild(titleContainer)

  local spacer  = EasyReminders.AceGUI:Create("Label")
  spacer:SetText("")
  spacer:SetWidth(10)
  titleContainer:AddChild(spacer)

  local potionTitle = EasyReminders.AceGUI:Create("Label")
  potionTitle:SetText(L["Item"])
  potionTitle:SetWidth(220)
  titleContainer:AddChild(potionTitle)

  --
  local buffTitle = EasyReminders.AceGUI:Create("Label")
  buffTitle:SetText(L["Tracked Buff"])
  buffTitle:SetWidth(220)
  titleContainer:AddChild(buffTitle)

  local raidTitle = EasyReminders.AceGUI:Create("Label")
  raidTitle:SetText(L["Raid"])
  raidTitle:SetWidth(50)
  titleContainer:AddChild(raidTitle)

  local dungeonTitle = EasyReminders.AceGUI:Create("Label")
  dungeonTitle:SetText(L["Dungeon"])
  dungeonTitle:SetWidth(50)
  titleContainer:AddChild(dungeonTitle)

  local pvpTitle = EasyReminders.AceGUI:Create("Label")
  pvpTitle:SetText(L["PvP"])
  pvpTitle:SetWidth(50)
  titleContainer:AddChild(pvpTitle)

  local delveTitle = EasyReminders.AceGUI:Create("Label")
  delveTitle:SetText(L["Delve"])
  delveTitle:SetWidth(50)
  titleContainer:AddChild(delveTitle)

  local outsideTitle = EasyReminders.AceGUI:Create("Label")
  outsideTitle:SetText(L["Outside"])
  outsideTitle:SetWidth(50)
  titleContainer:AddChild(outsideTitle)

  
  ConsumablesTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)

  ConsumablesTab:RebuildScrollBox()

end

function ConsumablesTab:RebuildScrollBox()
  local scrollBox = ConsumablesTab.ScrollBox
  scrollBox:ReleaseChildren()

  for key, data in pairs(EasyReminders.ConsumableCache)  do

    local itemName = C_Item.GetItemNameByID(data.itemID)
    local itemIcon = C_Item.GetItemIconByID(data.itemID)
    local spellInfo = C_Spell.GetSpellInfo(data.buffID)

    ---
    local potionName = EasyReminders.AceGUI:Create("Label")
    potionName:SetText(itemName or L["Loading..."])
    potionName:SetFont(EasyReminders.Font, 12, "")
    potionName:SetWidth(220)
    potionName:SetImage(itemIcon)
    potionName:SetImageSize(16,16)
    scrollBox:AddChild(potionName)

    --
    local buffName = EasyReminders.AceGUI:Create("Label")
    buffName:SetText((spellInfo and spellInfo.name) or L["Loading..."])
    buffName:SetFont(EasyReminders.Font, 12, "")
    buffName:SetWidth(220)
    buffName:SetImage((spellInfo and spellInfo.iconID) or nil)
    buffName:SetImageSize(16,16)
    scrollBox:AddChild(buffName)

    EasyReminders:AddData(data.itemID, itemName, itemIcon, spellInfo)
    if data.otherIds then
      for key, otherID in pairs(data.otherIds) do
        EasyReminders:AddData(otherID, itemName, C_Item.GetItemIconByID(otherID), spellInfo)
      end
    end

    local raid = EasyReminders.AceGUI:Create("CheckBox")
    raid:SetType("checkbox")
    raid:SetValue(false)
    raid:SetWidth(50)
    raid:SetValue((EasyReminders.charDB.potions[data.itemID] and EasyReminders.charDB.potions[data.itemID].raid) or false)
    scrollBox:AddChild(raid)
    raid:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.potions[data.itemID] = EasyReminders.charDB.potions[data.itemID] or {}
      EasyReminders.charDB.potions[data.itemID].raid = value
      EasyReminders.ConsumableCheck:BuildTrackingList()
      EasyReminders:CheckBuffs()
    end)

    local dungeon = EasyReminders.AceGUI:Create("CheckBox")
    dungeon:SetType("checkbox")
    dungeon:SetValue(false)
    dungeon:SetWidth(50)
    dungeon:SetValue((EasyReminders.charDB.potions[data.itemID] and EasyReminders.charDB.potions[data.itemID].dungeon) or false)
    dungeon:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.potions[data.itemID] = EasyReminders.charDB.potions[data.itemID] or {}
      EasyReminders.charDB.potions[data.itemID].dungeon = value
      EasyReminders.ConsumableCheck:BuildTrackingList()
      EasyReminders:CheckBuffs()
    end)
    scrollBox:AddChild(dungeon)

    local pvp = EasyReminders.AceGUI:Create("CheckBox")
    pvp:SetType("checkbox")
    pvp:SetValue(false)
    pvp:SetWidth(50)
    pvp:SetValue((EasyReminders.charDB.potions[data.itemID] and EasyReminders.charDB.potions[data.itemID].pvp) or false)
    pvp:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.potions[data.itemID] = EasyReminders.charDB.potions[data.itemID] or {}
      EasyReminders.charDB.potions[data.itemID].pvp = value
      EasyReminders.ConsumableCheck:BuildTrackingList()
      EasyReminders:CheckBuffs()
    end)
    scrollBox:AddChild(pvp)

    local delve = EasyReminders.AceGUI:Create("CheckBox")
    delve:SetType("checkbox")
    delve:SetValue(false)
    delve:SetWidth(50)
    delve:SetValue((EasyReminders.charDB.potions[data.itemID] and EasyReminders.charDB.potions[data.itemID].delve) or false)
    delve:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.potions[data.itemID] = EasyReminders.charDB.potions[data.itemID] or {}
      EasyReminders.charDB.potions[data.itemID].delve = value
      EasyReminders.ConsumableCheck:BuildTrackingList()
      EasyReminders:CheckBuffs()
    end)
    scrollBox:AddChild(delve)

    local outside = EasyReminders.AceGUI:Create("CheckBox")
    outside:SetType("checkbox")
    outside:SetValue(false)
    outside:SetWidth(50)
    outside:SetValue((EasyReminders.charDB.potions[data.itemID] and EasyReminders.charDB.potions[data.itemID].outside) or false)
    outside:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.potions[data.itemID] = EasyReminders.charDB.potions[data.itemID] or {}
      EasyReminders.charDB.potions[data.itemID].outside = value
      EasyReminders.ConsumableCheck:BuildTrackingList()
      EasyReminders:CheckBuffs()
    end)
    scrollBox:AddChild(outside)

    if data["canDelete"] then 

      local delete = EasyReminders.AceGUI:Create("Icon")
      delete:SetImage("Interface\\AddOns\\WoWPro\\Textures\\Delete")
      delete:SetImageSize(16,16)
      delete:SetWidth(20)
      delete:SetCallback("OnClick", function()
        ConsumablesTab:RemoveConfirm(data.itemID, itemName)
      end)
      scrollBox:AddChild(delete)
    end

  end
end

function ConsumablesTab:RemoveConfirm(itemID, itemName)
    local dialogFrame = EasyReminders.AceGUI:Create("Window")
    dialogFrame:SetWidth(220)
    dialogFrame:SetHeight(100)
    dialogFrame:SetTitle("Confirm Removal")
    dialogFrame:SetLayout("Flow")
    dialogFrame:EnableResize(false)
    dialogFrame.frame:SetFrameStrata("DIALOG")
    dialogFrame.frame:Raise()

    local text =  EasyReminders.AceGUI:Create("Label")
    text:SetText(string.format(L["Are you sure you want to remove %s?"], itemName))
    dialogFrame:AddChild(text)

    local yes=EasyReminders.AceGUI:Create("Button")
    dialogFrame:AddChild(yes)
    yes:SetText("Yes")
    yes:SetWidth(90)
    yes:SetCallback("OnClick", function(widget) 
      ConsumablesTab:RemoveReminder(itemID) 
      dialogFrame:Hide()
    end)

    local no=EasyReminders.AceGUI:Create("Button")
    dialogFrame:AddChild(no)
    no:SetWidth(90)
    no:SetText("No")
    no:SetCallback("OnClick", function(widget) 
      dialogFrame:Hide()
    end)


end

function ConsumablesTab:RemoveReminder(itemID)

  -- Confirmation Dialog

  EasyReminders.globalDB.customConsumables[itemID] = nil
  EasyReminders.charDB.potions[itemID] = nil

  if EasyReminders.Data.Consumables[itemID] then
    EasyReminders.ConsumableCache[itemID] = EasyReminders.Data.Consumables[itemID]
  else
    EasyReminders.ConsumableCache[itemID] = nil
  end

  EasyReminders.ConsumableCheck:BuildTrackingList()
  EasyReminders:CheckBuffs()
  ConsumablesTab:RebuildScrollBox()
 
end



