EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.ConsumablesDialog = EasyReminders.UI.ConsumablesDialog or {}

local ConsumablesDialog = EasyReminders.UI.ConsumablesDialog

local L = LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

local itemID, itemName, itemIcon
local spellID, spellName, spellIcon
local additionalItems, statusText

local function setCloseOnEscPress(window)
   local oldCloseSpecialWindows = CloseSpecialWindows
    CloseSpecialWindows = function()
		if window:IsShown() then
			window:Hide()
			return true
		end

		return oldCloseSpecialWindows()
	end
end

--local itemID = tonumber(strmatch(itemLink, "item:(%d+):"))

function ConsumablesDialog:FindItemByName()

  local name = itemName:GetText()
  local itemLink, id, icon
  EasyReminders:Print("Searching..." .. name)
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
      itemID:SetText("invalid!")
  end

end

function ConsumablesDialog:FindItemByID()
  EasyReminders:Print("Searching...")
  local text = itemID:GetText()
    local id = tonumber(text)
      if id then
        local name = C_Item.GetItemNameByID(id)
        local icon = C_Item.GetItemIconByID(id)

        if not name then
          name = C_Item.GetItemNameByID(id)
        end


        if not name then
          name = "Not found"
        end

        itemName:SetText(name)

        if icon then 
          itemIcon:SetImage(icon)
        end
      else
         itemID:SetText("invalid!")
         itemName:SetText("")
         itemIcon:SetImage(nil)
      end

end

function ConsumablesDialog:FindSpellByID()
  EasyReminders:Print("Searching...")
  local text = spellID:GetText()
  local id = tonumber(text)
  local name, icon
  if id then

    local spellInfo = C_Spell.GetSpellInfo(id)


    if not spellInfo or not spellInfo.name then
      name = "Not found"
    else
      name = spellInfo.name
    end

    spellName:SetText(name)

    if spellInfo then 
      spellName:SetImage(spellInfo.iconID)
    else
      spellName:SetImage(nil)
    end
  else
      spellID:SetText("invalid!")
      spellName:SetText("")
      spellName:SetImage(nil)
  end

end

local function validateItems()
  local str = additionalItems:GetText()
  if str == "" then
    EasyReminders:Print("No additional items entered.")
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
    EasyReminders:Print("Additional items are valid.")
    return true
  else
    EasyReminders:Print("Invalid input: must be comma-separated numbers.")
    additionalItems:SetText("invalid!")
    return false
  end
end

function ConsumablesDialog:AddReminder()


  if not validateId(itemID.GetText()) or not itemName.GetText() or not itemIcon.GetImage() then
    stausText = "Invalid Item"
    return
  end

  if not validateId(spellID.GetText()) or not spellName.GetText() or not spellIcon.GetImage() then
    statusText = "Invalid Spell"
    return
  end

  if not validateNumbers() then
    statusText = "Invalid Additonal Items"
    return
  end

  local reminderData = {["itemID"] = itemID.GetText(), ["buffID"] = spellID.GetText()}

  if additionalItems.GetText() and additionalItems.getText().len() > 0 then
    reminderData["otherIds"] = additionalItems.GetText()
  end

  -- TODO: add to a list of custom consumables
  -- TODO: Add them to the main dialog tab
  -- TODO: Don't think the checker needs any helo!

end

function ConsumablesDialog:Create(mainFrame)
    local dialogFrame = EasyReminders.AceGUI:Create("Window")
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
    itemID:SetLabel("Item ID: ")
    itemID:SetMaxLetters(10)
    itemID:SetCallback("OnEnterPressed", function(widget) ConsumablesDialog:FindItemByID() end)
    dialogFrame:AddChild(itemID)

      itemIcon = EasyReminders.AceGUI:Create("Label")
    itemIcon:SetImageSize(16,16)
    itemIcon:SetWidth(20)
    itemIcon:SetHeight(16)
    itemIcon:SetPoint("TOPRIGHT", itemID.frame, "TOPLEFT", 5, 0)
    dialogFrame:AddChild(itemIcon)


    itemName = EasyReminders.AceGUI:Create("EditBox")
    itemName:SetLabel("Item Name: ")
    itemName:SetMaxLetters(40)
    itemName:SetWidth(300)
    itemName:SetCallback("OnEnterPressed", function(widget) ConsumablesDialog:FindItemByName() end)
    dialogFrame:AddChild(itemName)

      -- Buff details

    spellID = EasyReminders.AceGUI:Create("EditBox")
    spellID:SetLabel("Spell ID: ")
    spellID:SetMaxLetters(10)
    spellID:SetCallback("OnEnterPressed", function(widget) ConsumablesDialog:FindSpellByID() end)
    dialogFrame:AddChild(spellID)

    spellName = EasyReminders.AceGUI:Create("Label")
    spellName:SetText(" ")
    spellName:SetImageSize(16,16)
    spellName:SetWidth(250)
    spellName:SetFont(EasyReminders.Font, 12, "")
    spellName:SetHeight(16)
    spellName:SetPoint("TOPRIGHT", spellID.frame, "TOPLEFT", 5, 0)
    dialogFrame:AddChild(spellName)

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
    addItemButton:SetCallback("OnClick", function(widget) ConsumablesDialog:AddReminder() end)

    statusText = EasyReminders.AceGUI:Create("Label")
    statusText:SetText(" ")
    statusText:SetFullWidth(true)
    statusText:SetFont(EasyReminders.Font, 12, "")
    statusText:SetHeight(16)
    dialogFrame:AddChild(statusText)

    return mainFrame

end
