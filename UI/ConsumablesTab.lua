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

  ConsumablesTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)

  ConsumablesTab:RebuildScrollBox()

end

function ConsumablesTab:RebuildScrollBox()

  local scrollBox = ConsumablesTab.ScrollBox
  scrollBox:ReleaseChildren()

  for key, data in pairs(EasyReminders.ConsumableCache)  do

    -- itemID, itemName, itemIcon, spellInfo
    local cacheEntry = EasyReminders.DataCache[data.itemID] or {}

    local itemName = cacheEntry[2] or C_Item.GetItemNameByID(data.itemID)
    local itemIcon = cacheEntry[3] or C_Item.GetItemIconByID(data.itemID)
    local spellInfo = cacheEntry[4] or C_Spell.GetSpellInfo(data.buffID)

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

    ---
    local potionName = EasyReminders.AceGUI:Create("Label")
    potionName:SetText(itemName or L["Loading..."])
    potionName:SetFont(EasyReminders.Font, 12, "")
    potionName:SetWidth(220)
    potionName:SetImage(itemIcon)
    potionName:SetImageSize(16,16)
    scrollBox:AddChild(potionName)

    -- For soem reason havign this column can case checkboxes to go AWOL
    local buffName = EasyReminders.AceGUI:Create("Label")
    buffName:SetText((spellInfo and spellInfo.name) or L["Loading..."])
    buffName:SetFont(EasyReminders.Font, 12, "")
    buffName:SetWidth(220)
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

    EasyReminders.charDB.potions[data.itemID] = EasyReminders.charDB.potions[data.itemID] or {}
    activeDropdown:SetMultiselect(true)
    activeDropdown:SetItemValue("Raid", EasyReminders.charDB.potions[data.itemID].raid or false)
    activeDropdown:SetItemValue("Dungeon", EasyReminders.charDB.potions[data.itemID].dungeon or false)
    activeDropdown:SetItemValue("Delve", EasyReminders.charDB.potions[data.itemID].delve or false)
    activeDropdown:SetItemValue("Outside", EasyReminders.charDB.potions[data.itemID].outside or false)
    scrollBox:AddChild(activeDropdown)
    activeDropdown:SetCallback("OnValueChanged", function(_,_,key, checked)
      if "Raid" == key then
        EasyReminders.charDB.potions[data.itemID].raid = checked
      elseif "Dungeon" == key then
        EasyReminders.charDB.potions[data.itemID].dungeon = checked
      elseif "Delve" == key then
        EasyReminders.charDB.potions[data.itemID].delve = checked
      elseif "Outside" == key then
        EasyReminders.charDB.potions[data.itemID].outside = checked
      end
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



