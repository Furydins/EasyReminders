EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.GearTab = EasyReminders.UI.GearTab or {}

local GearTab = EasyReminders.UI.GearTab

EasyReminders.Filters = EasyReminders.Filters or {}
EasyReminders.Filters.gear = EasyReminders.Filters.gear or {}

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

-- function that draws the widgets for the first tab
function GearTab:Create(mainFrame, container)

    EasyReminders.Filters.gear = {["MIDNIGHT"] = EasyReminders.charDB.filterConsumables.MIDNIGHT,
                ["TWW"] = EasyReminders.charDB.filterConsumables.TWW,  
                ["CUSTOM"] = EasyReminders.charDB.filterConsumables.CUSTOM,
                ["OTHER"] = EasyReminders.charDB.filterConsumables.OTHER}

    local addItemButton = EasyReminders.AceGUI:Create("Button")
    container:AddChild(addItemButton)
    addItemButton:SetText(L["Add Item"])
    addItemButton:SetCallback("OnClick", function(widget) EasyReminders.UI.GearDialog:Create(mainFrame) end)

    local filterText = EasyReminders.AceGUI:Create("Label")
    filterText:SetText(L["Filter:"])
    filterText:SetWidth(40)
    container:AddChild(filterText)

    local filterDropdown = EasyReminders.AceGUI:Create("Dropdown")
    filterDropdown:SetWidth(150)
    filterDropdown:SetList({
        [EasyReminders.Data.Expansions.MIDNIGHT] = L["Midnight"],
        [EasyReminders.Data.Expansions.TWW] = L["The War Within"],
        [EasyReminders.Data.Expansions.CUSTOM] = L["Custom"],
        [EasyReminders.Data.Expansions.OTHER] = L["Other Items"],
    })
    filterDropdown:SetMultiselect(true)
    filterDropdown:SetItemValue(EasyReminders.Data.Expansions.MIDNIGHT, EasyReminders.Filters.gear.MIDNIGHT)
    filterDropdown:SetItemValue(EasyReminders.Data.Expansions.TWW, EasyReminders.Filters.gear.TWW)
    filterDropdown:SetItemValue(EasyReminders.Data.Expansions.CUSTOM, EasyReminders.Filters.gear.CUSTOM)
    filterDropdown:SetItemValue(EasyReminders.Data.Expansions.OTHER, EasyReminders.Filters.gear.OTHER)
    container:AddChild(filterDropdown)

  filterDropdown:SetCallback("OnValueChanged", function(_,_,key, checked)
    EasyReminders.Filters.gear[key] = checked
    EasyReminders.charDB.filterGear[key] = checked
    GearTab:RebuildScrollBox()
  end)

    local minTimeLabel = EasyReminders.AceGUI:Create("Label")
    minTimeLabel:SetText("  " .. L["Min Time Left (min)"])
    minTimeLabel:SetWidth(120)
    container:AddChild(minTimeLabel)
    local minTimer = EasyReminders.AceGUI:Create("EditBox")
    minTimer:SetWidth(70)
    minTimer:SetText(tostring(EasyReminders.charDB.gearMinTime or 0))
    container:AddChild(minTimer)
    minTimer:SetCallback("OnEnterPressed", function(_,_,text)
    local num = tonumber(text)
    if num then
        EasyReminders.charDB.gearMinTime = num
    else
        EasyReminders.charDB.gearMinTime = 0
    end
    -- EasyReminders.GearCheck:BuildTrackingList()
    EasyReminders:CheckBuffs()
    end)

    GearTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)

    GearTab:RebuildScrollBox()

end

function GearTab:RebuildScrollBox()
  local scrollBox = GearTab.ScrollBox
  scrollBox:ReleaseChildren()

  local _, class, _ = _G.UnitClass("player")


  -- Main enchants and Gems
  for key, data in pairs(EasyReminders.Data.Gear)  do
    if data.enchantable or data.gemable or data.consumable then
      local itemIcon = C_Item.GetItemIcon({equipmentSlotIndex = data.slotID})

      local slotName = EasyReminders.AceGUI:Create("Label")
      buffName:SetText(data.slotName)
      buffName:SetFont(EasyReminders.Font, 12, "")
      buffName:SetWidth(440)
      buffName:SetImage("itemIcon")
      buffName:SetImageSize(16,16)
      scrollBox:AddChild(buffName)

      local activeDropdown = EasyReminders.AceGUI:Create("Dropdown")
      activeDropdown:SetWidth(150)
      activeDropdown:SetList({
        ["Enchant"] = L["Enchant"],
        ["Gem"] = L["Gem"],
        ["Consumable"] = L["Consumable"],
      })

      EasyReminders.charDB.gear[data.slotID] = EasyReminders.charDB.gear[data.slotID] or {}
      activeDropdown:SetMultiselect(true)
      activeDropdown:SetItemDisabled("Enchant", not data.enchantable)
      activeDropdown:SetItemValue("Enchant", EasyReminders.charDB.gear[data.slotID].enchant or false)
      activeDropdown:SetItemDisabled("Gem", not data.gemable)
      activeDropdown:SetItemValue("Gem", EasyReminders.charDB.gear[data.slotID].gem or false)
      activeDropdown:SetItemDisabled("Consumable", not data.consumable)

      activeDropdown:SetItemValue("Consumable", EasyReminders.charDB.gear[data.slotID].consumable or false)
      scrollBox:AddChild(activeDropdown)
      activeDropdown:SetCallback("OnValueChanged", function(_,_,key, checked)
        if "Enchant" == key then
          EasyReminders.charDB.gear[data.slotID].enchant = checked
        elseif "Gem" == key then
          EasyReminders.charDB.gear[data.slotID].gem = checked
        elseif "Consumable" == key then
          EasyReminders.charDB.gear[data.slotID].consumable = checked
        end
        -- EasyReminders.GearCheck:BuildTrackingList()
        EasyReminders:CheckBuffs()
      end)

    end
  end

  local seperator - EasyReminders.AceGUI:Create("Heading")
  seperator:SetText(L["Gear Consumables (Weightstones, Oils, etc)"])
  seperator:SetFullWidth(true)
  scrollBox:AddChild(seperator)

  -- Consumable Enhancements like Oils and Weightstones
  for key, data in pairs(EasyReminders.Data.GearConsumables)  do
   if not data.class or data.class == class then

     -- itemID, itemName, itemIcon, spellInfo
      local cacheEntry = EasyReminders.DataCache[data.itemID] or {}

      local itemName = cacheEntry[2] or C_Item.GetItemNameByID(data.itemID)
      local itemIcon = cacheEntry[3] or C_Item.GetItemIconByID(data.itemID)
      local spellInfo = cacheEntry[4] or C_Spell.GetSpellInfo(data.buffID)
      local slotName = EasyReminders.Data.Gear[data.slotID].slotName

      -- Prime item Data
      if data.otherIds then
        for key, otherID in pairs(data.otherIds) do
            if not EasyReminders.DataCache[otherID] then
              local otherItemName = C_Item.GetItemNameByID(otherID)
              local otherItemIcon = C_Item.GetItemIconByID(otherID)
              EasyReminders.DataCache[otherID] = {otherID, otherItemName, otherItemIcon, nil}
            end
        end
      end

      local itemName = EasyReminders.AceGUI:Create("Label")
      itemName:SetText(itemName or L["Loading..."])
      itemName:SetFont(EasyReminders.Font, 12, "")
      itemName:SetWidth(220)
      itemName:SetImage(itemIcon)
      itemName:SetImageSize(16,16)
      scrollBox:AddChild(itemName)

      local activeDropdown = EasyReminders.AceGUI:Create("Dropdown")
      activeDropdown:SetWidth(150)
      activeDropdown:SetList({
        ["Raid"] = L["Raid"],
        ["Dungeon"] = L["Dungeon"],
        ["Delve"] = L["Delve"],
        ["Outside"] = L["Outside"],
      })

    EasyReminders.charDB.gearConsumables[data.itemID] = EasyReminders.charDB.gearConsumables[data.itemID] or {}
      activeDropdown:SetMultiselect(true)
      activeDropdown:SetItemValue("Raid", EasyReminders.charDB.gearConsumables[data.itemID].raid or false)
      activeDropdown:SetItemValue("Dungeon", EasyReminders.charDB.gearConsumables[data.itemID].dungeon or false)
      activeDropdown:SetItemValue("Delve", EasyReminders.charDB.gearConsumables[data.itemID].delve or false)
      activeDropdown:SetItemValue("Outside", EasyReminders.charDB.gearConsumables[data.itemID].outside or false)
      scrollBox:AddChild(activeDropdown)
      activeDropdown:SetCallback("OnValueChanged", function(_,_,key, checked)
        if "Raid" == key then
          EasyReminders.charDB.gearConsumables[data.itemID].raid = checked
        elseif "Dungeon" == key then
          EasyReminders.charDB.gearConsumables[data.itemID].dungeon = checked
        elseif "Delve" == key then
          EasyReminders.charDB.gearConsumables[data.itemID].delve = checked
        elseif "Outside" == key then
          EasyReminders.charDB.gearConsumables[data.itemID].outside = checked
        end
        -- EasyReminders.GearCheck:BuildTrackingList()
        EasyReminders:CheckBuffs()
      end)

    end
  end
end

function GearTab:RemoveConfirm(itemID, itemName)
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
      GearTab:RemoveReminder(itemID) 
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

function GearTab:RemoveReminder(itemID)

  -- Confirmation Dialog

  EasyReminders.globalDB.customGearConsumables[itemID] = nil
  EasyReminders.charDB.gearConsumables[itemID] = nil

  if EasyReminders.Data.GearConsumables[itemID] then
    EasyReminders.GearConsumableCache[itemID] = EasyReminders.Data.GearConsumables[itemID]
  else
    EasyReminders.GearConsumableCache[itemID] = nil
  end

  -- EasyReminders.GearCheck:BuildTrackingList()
  EasyReminders:CheckBuffs()
  GearTab:RebuildScrollBox()
 
end