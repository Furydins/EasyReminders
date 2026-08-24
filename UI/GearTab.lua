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
    filterText:SetWidth(30)
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

    local minDurabilityLabel = EasyReminders.AceGUI:Create("Label")
    minDurabilityLabel:SetText(" " .. L["Min Durability"] .. "(%):")
    minDurabilityLabel:SetWidth(97)
    container:AddChild(minDurabilityLabel)
    local minDurability = EasyReminders.AceGUI:Create("EditBox")
    minDurability:SetWidth(70)
    minDurability:SetText(tostring(EasyReminders.charDB.minDurability or 0))
    container:AddChild(minDurability)
    minDurability:SetCallback("OnEnterPressed", function(_,_,text)
      local num = tonumber(text)
      if num then
          EasyReminders.charDB.minDurability = num
      else
          EasyReminders.charDB.minDurability = 0
      end
      EasyReminders.TemporaryEnchantCheck:BuildTrackingList()
      EasyReminders:CheckBuffs("REFRESH")
    end)

    local minTimeLabel = EasyReminders.AceGUI:Create("Label")
    minTimeLabel:SetText("  " .. L["Min Time Left (min)"] .. ":")
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
      EasyReminders.TemporaryEnchantCheck:BuildTrackingList()
      EasyReminders:CheckBuffs("REFRESH")
    end)


    GearTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)
    
    GearTab:RebuildScrollBox()

end

function GearTab:RebuildScrollBox()
  local scrollBox = GearTab.ScrollBox
  scrollBox:ReleaseChildren()

  local _, class, _ = _G.UnitClass("player")

  local seperator1 = EasyReminders.AceGUI:Create("Heading")
  seperator1:SetText(L["Permanent Enchants and Gems"])
  seperator1:SetFullWidth(true)
  scrollBox:AddChild(seperator1)


  -- Main enchants and Gems
  for i = 1, #EasyReminders.Data.GearSlots do
    local data = EasyReminders.Data.GearSlots[i]

    if data.enchantable or data.gemable or data.consumable then
      local itemIcon = C_Item.GetItemIcon({equipmentSlotIndex = data.slotID})

      local slotName = EasyReminders.AceGUI:Create("Label")
      slotName:SetText(data.slotName)
      slotName:SetFont(EasyReminders.Font, 12, "")
      slotName:SetWidth(440)
      slotName:SetImage("itemIcon")
      slotName:SetImageSize(16,16)
      scrollBox:AddChild(slotName)

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
        EasyReminders:CheckBuffs("REFRESH")
      end)

    end
  end

  local seperator2 = EasyReminders.AceGUI:Create("Heading")
  seperator2:SetText(L["Temporary Buffs and Consumables"])
  seperator2:SetFullWidth(true)
  scrollBox:AddChild(seperator2)

   -- class weapon imbues
  local _, class, _ = _G.UnitClass("player")
  for key, data in pairs(EasyReminders.Data.ClassEnchants)  do

    if data.class == class then
      local spellInfo = C_Spell.GetSpellInfo(data.spellID)

      local buffName = EasyReminders.AceGUI:Create("Label")
      buffName:SetText(spellInfo and spellInfo.name or L["Loading..."])
      buffName:SetFont(EasyReminders.Font, 12, "")
      buffName:SetWidth(440)
      buffName:SetImage((spellInfo and spellInfo.iconID) or nil)
      buffName:SetImageSize(16,16)
      scrollBox:AddChild(buffName)

      local activeDropdown = EasyReminders.AceGUI:Create("Dropdown")
      activeDropdown:SetWidth(150)
      activeDropdown:SetList({
        ["Raid"] = L["Raid"],
        ["Dungeon"] = L["Dungeon"],
        ["Delve"] = L["Delve"],
        ["Outside"] = L["Outside"],
      })

      EasyReminders.charDB.gearImbues[data.buffID] = EasyReminders.charDB.gearImbues[data.buffID] or {}
      activeDropdown:SetMultiselect(true)
      activeDropdown:SetItemValue("Raid", EasyReminders.charDB.gearImbues[data.buffID].raid or false)
      activeDropdown:SetItemValue("Dungeon", EasyReminders.charDB.gearImbues[data.buffID].dungeon or false)
      activeDropdown:SetItemValue("Delve", EasyReminders.charDB.gearImbues[data.buffID].delve or false)
      activeDropdown:SetItemValue("Outside", EasyReminders.charDB.gearImbues[data.buffID].outside or false)
      scrollBox:AddChild(activeDropdown)
      activeDropdown:SetCallback("OnValueChanged", function(_,_,key, checked)
        if "Raid" == key then
          EasyReminders.charDB.gearImbues[data.buffID].raid = checked
        elseif "Dungeon" == key then
          EasyReminders.charDB.gearImbues[data.buffID].dungeon = checked
        elseif "Delve" == key then
          EasyReminders.charDB.gearImbues[data.buffID].delve = checked
        elseif "Outside" == key then
          EasyReminders.charDB.gearImbues[data.buffID].outside = checked
        end
        EasyReminders.TemporaryEnchantCheck:BuildTrackingList()
        EasyReminders:CheckBuffs(REFRESH)
      end)
    end
  end

    -- Consumable Enhancements like Oils and Weightstones
  local entries = {}

  for key, data in pairs(EasyReminders.GearConsumablesCache)  do
   if not data.class or data.class == class then

     -- itemID, itemName, itemIcon, spellInfo
      local cacheEntry = EasyReminders.DataCache[data.itemID] or {}

      local itemName = cacheEntry[2] or C_Item.GetItemNameByID(data.itemID)
      local itemIcon = cacheEntry[3] or C_Item.GetItemIconByID(data.itemID)
      if data.slotID then
        local slotName = EasyReminders.Data.GearSlots[data.slotID].slotName
      else 
        slotName = "Missing Slot" 
      end

      -- Prime item Data
      if data.otherIds then
        for key, otherID in pairs(data.otherIds) do
            if not EasyReminders.DataCache[otherID] then
              local otherItemName = C_Item.GetItemNameByID(otherID)
              local otherItemIcon = C_Item.GetItemIconByID(otherID)
              local _,_,_,_,_,_,_,itemStackCount = C_Item.GetItemInfo(otherID)
              EasyReminders.DataCache[otherID] = {otherID, otherItemName, otherItemIcon, nil, itemStackCount}
            end
        end
      end

      table.insert(entries, {
        data = data,
        itemName = itemName,
        itemIcon = itemIcon,
        slotName = slotName,
      })
    end
  end

  table.sort(entries, function(a, b)
    local nameA = a.itemName or ""
    local nameB = b.itemName or ""
    if nameA ~= nameB then
      return nameA < nameB
    end
    return (a.data.itemID or 0) < (b.data.itemID or 0)
  end)


   for _, entry in ipairs(entries) do
    local data = entry.data
    local itemName = entry.itemName
    local itemIcon = entry.itemIcon
    local slotName = entry.slotName

    local itemNameLabel = EasyReminders.AceGUI:Create("Label")
    itemNameLabel:SetText(itemName or L["Loading..."])
    itemNameLabel:SetFont(EasyReminders.Font, 12, "")
    itemNameLabel:SetWidth(440)
    itemNameLabel:SetImage(itemIcon)
    itemNameLabel:SetImageSize(16,16)
    scrollBox:AddChild(itemNameLabel)

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
      EasyReminders.TemporaryEnchantCheck:BuildTrackingList()
      EasyReminders:CheckBuffs("REFRESH")
    end)

    if data["canDelete"] then 

      local delete = EasyReminders.AceGUI:Create("Icon")
      delete:SetImage("Interface\\AddOns\\WoWPro\\Textures\\Delete")
      delete:SetImageSize(16,16)
      delete:SetWidth(20)
      delete:SetCallback("OnClick", function()
        GearTab:RemoveConfirm(data.itemID, itemName)
      end)
      scrollBox:AddChild(delete)
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
    EasyReminders.GearConsumablesCache[itemID] = EasyReminders.Data.GearConsumables[itemID]
  else
    EasyReminders.GearConsumablesCache[itemID] = nil
  end

  EasyReminders.TemporaryEnchantCheck:BuildTrackingList()
  EasyReminders:CheckBuffs("REFRESH")
  GearTab:RebuildScrollBox()
 
end