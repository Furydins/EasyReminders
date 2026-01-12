EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.ConsumablesTab = EasyReminders.UI.ConsumablesTab or {}

local ConsumablesTab = EasyReminders.UI.ConsumablesTab

EasyReminders.Filters = {["MIDNIGHT"] = true,  
                   ["TWW"] = true,  
                   ["OTHER"] = true,}

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

-- function that draws the widgets for the first tab
function ConsumablesTab:Create(mainFrame, container)

  local addItemButton = EasyReminders.AceGUI:Create("Button")
  container:AddChild(addItemButton)
  addItemButton:SetText(L["Add Item"])
  addItemButton:SetCallback("OnClick", function(widget) EasyReminders.UI.ConsumablesDialog:Create(mainFrame) end)

  local filterText = EasyReminders.AceGUI:Create("Label")
  filterText:SetText(L["Filter:"])
  filterText:SetWidth(40)
  container:AddChild(filterText)

  local filterDropdown = EasyReminders.AceGUI:Create("Dropdown")
  filterDropdown:SetWidth(150)
  filterDropdown:SetList({
    [EasyReminders.Data.Expansions.MIDNIGHT] = L["Midnight"],
    [EasyReminders.Data.Expansions.TWW] = L["The War Within"],
    [EasyReminders.Data.Expansions.OTHER] = L["Other Items"],
  })
  filterDropdown:SetMultiselect(true)
  filterDropdown:SetItemValue(EasyReminders.Data.Expansions.MIDNIGHT, EasyReminders.Filters.MIDNIGHT)
  filterDropdown:SetItemValue(EasyReminders.Data.Expansions.TWW, EasyReminders.Filters.TWW)
  filterDropdown:SetItemValue(EasyReminders.Data.Expansions.OTHER, EasyReminders.Filters.OTHER)
  container:AddChild(filterDropdown)
  filterDropdown:SetCallback("OnValueChanged", function(_,_,key, checked)
    EasyReminders.Filters[key] = checked
    ConsumablesTab:RebuildScrollBox()
  end)

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
  potionTitle:SetWidth(440)
  titleContainer:AddChild(potionTitle)

  -- Hide for for now as it messes up the checkboxes sometimes.
  --local buffTitle = EasyReminders.AceGUI:Create("Label")
  --buffTitle:SetText(L["Tracked Buff"])
  --buffTitle:SetWidth(220)
  --titleContainer:AddChild(buffTitle)

  local raidTitle = EasyReminders.AceGUI:Create("Label")
  raidTitle:SetText(L["Raid"])
  raidTitle:SetWidth(50)
  titleContainer:AddChild(raidTitle)

  local dungeonTitle = EasyReminders.AceGUI:Create("Label")
  dungeonTitle:SetText(L["Dungeon"])
  dungeonTitle:SetWidth(50)
  titleContainer:AddChild(dungeonTitle)

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

    if EasyReminders.Filters[data.expansion] then

      -- itemID, itemName, itemIcon, spellInfo
      local cacheEntry = EasyReminders.DataCache[data.itemID] or {}

      local itemName = cacheEntry[2] or C_Item.GetItemNameByID(data.itemID)
      local itemIcon = cacheEntry[3] or C_Item.GetItemIconByID(data.itemID)
      local spellInfo = cacheEntry[4] or C_Spell.GetSpellInfo(data.buffID)

      ---
      local potionName = EasyReminders.AceGUI:Create("Label")
      potionName:SetText(itemName or L["Loading..."])
      potionName:SetFont(EasyReminders.Font, 12, "")
      potionName:SetWidth(400)
      potionName:SetImage(itemIcon)
      potionName:SetImageSize(16,16)
      scrollBox:AddChild(potionName)

      -- For soem reason havign this column can case checkboxes to go AWOL
      --local buffName = EasyReminders.AceGUI:Create("Label")
      --buffName:SetText((spellInfo and spellInfo.name) or L["Loading..."])
      --buffName:SetFont(EasyReminders.Font, 12, "")
      --buffName:SetWidth(220)
      --buffName:SetImage((spellInfo and spellInfo.iconID) or nil)
      --buffName:SetImageSize(16,16)
      --scrollBox:AddChild(buffName)

      -- Prime item Data
      if data.otherIds then
        for key, otherID in pairs(data.otherIds) do
            C_Item.GetItemIconByID(otherID)
        end
      end

      local raid = EasyReminders.AceGUI:Create("CheckBox")
      raid:SetType("checkbox")
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
      dungeon:SetWidth(50)
      dungeon:SetValue((EasyReminders.charDB.potions[data.itemID] and EasyReminders.charDB.potions[data.itemID].dungeon) or false)
      scrollBox:AddChild(dungeon)
      dungeon:SetCallback("OnValueChanged", function(_,_,value)
        EasyReminders.charDB.potions[data.itemID] = EasyReminders.charDB.potions[data.itemID] or {}
        EasyReminders.charDB.potions[data.itemID].dungeon = value
        EasyReminders.ConsumableCheck:BuildTrackingList()
        EasyReminders:CheckBuffs()
      end)
    

      local delve = EasyReminders.AceGUI:Create("CheckBox")
      delve:SetType("checkbox")
      delve:SetWidth(50)
      delve:SetValue((EasyReminders.charDB.potions[data.itemID] and EasyReminders.charDB.potions[data.itemID].delve) or false)
      scrollBox:AddChild(delve)
      delve:SetCallback("OnValueChanged", function(_,_,value)
        EasyReminders.charDB.potions[data.itemID] = EasyReminders.charDB.potions[data.itemID] or {}
        EasyReminders.charDB.potions[data.itemID].delve = value
        EasyReminders.ConsumableCheck:BuildTrackingList()
        EasyReminders:CheckBuffs()
      end)


      local outside = EasyReminders.AceGUI:Create("CheckBox")
      outside:SetType("checkbox")
      outside:SetWidth(50)
      outside:SetValue((EasyReminders.charDB.potions[data.itemID] and EasyReminders.charDB.potions[data.itemID].outside) or false)
      scrollBox:AddChild(outside)
      outside:SetCallback("OnValueChanged", function(_,_,value)
        EasyReminders.charDB.potions[data.itemID] = EasyReminders.charDB.potions[data.itemID] or {}
        EasyReminders.charDB.potions[data.itemID].outside = value
        EasyReminders.ConsumableCheck:BuildTrackingList()
        EasyReminders:CheckBuffs()
      end)
    

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
    text:SetFont(EasyReminders.Font, 12, "")
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



