EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.GearDialog = EasyReminders.UI.GearDialog or {}

local GearDialog = EasyReminders.UI.GearDialog

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

local dialogFrame
local itemID, itemName, itemIcon, slotID, slotName
local additionalItems, statusText
local loadFrame

local function setCloseOnEscPress(window)
   local oldCloseSpecialWindows = CloseSpecialWindows
    CloseSpecialWindows = function()
		if window:IsShown() then
			window:Hide()
			return true
		end

		return oldCloseSpecialWindows()
	end
end--local itemID = tonumber(strmatch(itemLink, "item:(%d+):"))

function GearDialog:FindItemByName()

  local name = itemName:GetText()
  local itemLink, id, icon
  if name then
    _, itemLink = C_Item.GetItemInfo(name)

    if not itemLink then 
      _, itemLink = C_Item.GetItemInfo(name)
    end

    if not itemLink then
      id = "Not Found"
      icon = nil
    else 
      id = tonumber(strmatch(itemLink, "item:(%d+):"))
      icon = C_Item.GetItemIconByID(id)
    end 

    itemID:SetText(id)
    itemIcon:SetImage(icon)
  else
      itemID:SetText(L["Invalid"])
  end

end

-- Looking up item info fails if we havn't loaded the data
-- SO allow time for it to become available
function GearDialog:FindItemByID()
  local text = itemID:GetText()
  local id = tonumber(text)
  if id then
      local name = C_Item.GetItemNameByID(id)
      if not name then 
        itemName:SetText(L["Loading..."])
        if not loadFrame then
          loadFrame = _G.CreateFrame("Frame")
          loadFrame:SetScript("onEvent", function(frame, event, itemID, success)
              GearDialog:RetrieveFindByID(id, success)
          end)
        end
        loadFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
      else
        GearDialog:PopulateItems(name, id)
      end
  else
      itemID:SetText(L["Invalid"])
      itemName:SetText("")
      itemIcon:SetImage(nil)
  end
end

function GearDialog:RetrieveFindByID(id, success)

  local name = C_Item.GetItemNameByID(id)

  if not name then
    name = C_Item.GetItemNameByID(id)
  end

  if not name then
    name = "Failed"
    itemName:SetText("")
    itemIcon:SetImage(nil)
  else
    GearDialog:PopulateItems(name, id)
  end
  loadFrame:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
end

function GearDialog:PopulateItems(name, id)
  
  local icon = C_Item.GetItemIconByID(id)

  itemName:SetText(name)

  if icon then 
    itemIcon:SetImage(icon)
  end

end

local function validateItems()
  local str = additionalItems:GetText()
  if str == "" then
    return
  end
  local valid = true
  for num in string.gmatch(str, "([^,]+)") do
    num = num:match("^%s*(.-)%s*$")  -- trim whitespace
    if not tonumber(num) then
      valid = false
      break
    end
  end
  if valid then
    return true
  else
    additionalItems:SetText(L["Invalid"])
    return false
  end
end

local function validateID(id)
  if not tonumber(id) then
    return false
  else
    return true
  end
end

local function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, tonumber(match));
    end
    return result;
end

function GearDialog:AddReminder()

  if not validateID(itemID:GetText()) or not itemName:GetText() then
    statusText:SetText(L["Invalid Item"])
    return
  end

  if additionalItems:GetText() and string.len(additionalItems:GetText()) > 0 and not validateItems() then
    statusText:SetText(L["Invalid Additional Items"])
    return
  end

  local reminderData = {["itemID"] = tonumber(itemID:GetText()), ["slotID"] = tonumber(slotID)}

  if additionalItems:GetText() and string.len(additionalItems:GetText()) > 0 then
    reminderData["otherIds"] = split(additionalItems:GetText(), ",")

  end
  reminderData["canDelete"] = true
  reminderData["expansion"] = EasyReminders.Data.Expansions.CUSTOM

  EasyReminders.globalDB.customGearConsumables[reminderData.itemID] = reminderData
  EasyReminders.GearConsumablesCache[reminderData.itemID] = reminderData
  EasyReminders.charDB.gearConsumables[reminderData.itemID] = nil

  EasyReminders.UI.GearTab:RebuildScrollBox()

  statusText:SetText(L["Success!"])
  dialogFrame:Hide()

end

function GearDialog:Create(mainFrame)
    dialogFrame = EasyReminders.AceGUI:Create("Window")
    dialogFrame:SetWidth(600)
    dialogFrame:SetHeight(240)
    dialogFrame:SetTitle(L["Add Consumable"])
    dialogFrame:SetLayout("Flow")
    dialogFrame:EnableResize(false)
    dialogFrame.frame:SetFrameStrata("DIALOG")
    dialogFrame.frame:Raise()

    setCloseOnEscPress(dialogFrame)

    -- Item details

    itemID = EasyReminders.AceGUI:Create("EditBox")
    itemID:SetLabel(L["Item ID: "])
    itemID:SetMaxLetters(10)
    itemID:SetCallback("OnEnterPressed", function(widget) GearDialog:FindItemByID() end)
    dialogFrame:AddChild(itemID)

    itemIcon = EasyReminders.AceGUI:Create("Label")
    itemIcon:SetImageSize(16,16)
    itemIcon:SetWidth(20)
    itemIcon:SetHeight(16)
    itemIcon:SetPoint("TOPRIGHT", itemID.frame, "TOPLEFT", 5, 0)
    dialogFrame:AddChild(itemIcon)


    itemName = EasyReminders.AceGUI:Create("EditBox")
    itemName:SetLabel(L["Item Name: "])
    itemName:SetMaxLetters(40)
    itemName:SetWidth(300)
    itemName:SetCallback("OnEnterPressed", function(widget) ConsumablesDialog:FindItemByName() end)
    dialogFrame:AddChild(itemName)

    -- SLot Selector

    local slot = EasyReminders.AceGUI:Create("Dropdown")
    slot:SetWidth(150)
    slot:SetLabel(L["Gear Slot"])
    slot:SetList({
        ["HEADSLOT"] =  _G.HEADSLOT,
        ["NECKSLOT"] = _G.NECKSLOT,
        ["SHOULDERSLOT"] = _G.SHOULDERSLOT,
        ["CHESTSLOT"] = _G.CHESTSLOT,
        ["WAISTSLOT"] = _G.WAISTSLOT,
        ["LEGSSLOT"] = _G.LEGSSLOT,
        ["FEETSLOT"] = _G.FEETSLOT,
        ["WRISTSLOT"] = _G.WRISTSLOT,
        ["HANDSSLOT"] = _G.HANDSSLOT,
        ["FINGER0SLOT"] = _G.FINGER0SLOT,
        ["FINGER1SLOT"] = _G.FINGER1SLOT,
        ["TRINKET0SLOT"] = _G.TRINKET0SLOT,
        ["TRINKET1SLOT"] = _G.TRINKET1SLOT,
        ["BACKSLOT"] = _G.BACKSLOT,
        ["MAINHANDSLOT"] = _G.MAINHANDSLOT,
        ["SECONDARYHANDSLOT"] = _G.SECONDARYHANDSLOT
    },
    {"HEADSLOT", "NECKSLOT", "SHOULDERSLOT", "CHESTSLOT", "WAISTSLOT", "LEGSSLOT", "FEETSLOT", "WRISTSLOT", "HANDSSLOT", "FINGER0SLOT", "FINGER1SLOT", "TRINKET0SLOT", "TRINKET1SLOT", "BACKSLOT", "MAINHANDSLOT", "SECONDARYHANDSLOT"
    })

    slot:SetMultiselect(false)
    slot:SetItemValue(_G.HEADSLOT)
    dialogFrame:AddChild(slot)
    slot:SetCallback("OnValueChanged", function(_,_,key)    
        slotName = key
        slotID, _, _ = _G.GetInventorySlotInfo(key)
    end)

    ---- Extra items
    additionalItems = EasyReminders.AceGUI:Create("EditBox")
    additionalItems:SetLabel("Additional Item Ids: ")
    additionalItems:SetFullWidth(true)
    additionalItems:SetMaxLetters(150)
    additionalItems:SetCallback("OnEnterPressed", function(widget) validateItems() end)
    dialogFrame:AddChild(additionalItems)

    local addItemButton = EasyReminders.AceGUI:Create("Button")
    dialogFrame:AddChild(addItemButton)
    addItemButton:SetFullWidth(true)
    addItemButton:SetWidth(580)
    addItemButton:SetText("Create Reminder")
    addItemButton:SetCallback("OnClick", function(widget) GearDialog:AddReminder() end)

    statusText = EasyReminders.AceGUI:Create("Label")
    statusText:SetText(" ")
    statusText:SetFullWidth(true)
    statusText:SetFont(EasyReminders.Font, 12, "")
    statusText:SetHeight(16)
    dialogFrame:AddChild(statusText)

    return mainFrame

end
