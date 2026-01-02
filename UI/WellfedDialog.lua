EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.WellFedDialog = EasyReminders.UI.WellFedDialog or {}

local WellFedDialog = EasyReminders.UI.WellFedDialog

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

local dialogFrame
local itemID, itemName, itemIcon
local statusText

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

function WellFedDialog:FindItemByName()

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

    local _,itemSpell = C_Item.GetItemSpell(id)
    if itemSpell then
      spellID:SetText(itemSpell)
      ConsumablesDialog:FindSpellByID()
    end

    itemID:SetText(id)
    itemIcon:SetImage(icon)
  else
      itemID:SetText("invalid!")
  end

end

function WellFedDialog:FindItemByID()
  local text = itemID:GetText()
    local id = tonumber(text)
      if id then
        local name = C_Item.GetItemNameByID(id)
        local icon = C_Item.GetItemIconByID(id)
        local _, itemSpell = C_Item.GetItemSpell(id)

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

local function validateID(id)
  if not tonumber(id) then
    return false
  else
    return true
  end
end

function WellFedDialog:AddReminder()

  if not validateID(itemID:GetText()) or not itemName:GetText() then
    statusText:SetText("Invalid Item")
    return
  end

  local reminderData = {["itemID"] = tonumber(itemID:GetText())}

  reminderData["canDelete"] = true

  EasyReminders.globalDB.customFood[reminderData.itemID] = reminderData
  EasyReminders.FoodCache[reminderData.itemID] = reminderData
  EasyReminders.charDB.food[reminderData.itemID] = nil

  EasyReminders.UI.WellFedTab:RebuildScrollBox()

  statusText:SetText("Success!")
  dialogFrame:Hide()

end

function WellFedDialog:Create(mainFrame)
    dialogFrame = EasyReminders.AceGUI:Create("Window")
    dialogFrame:SetWidth(600)
    dialogFrame:SetHeight(150)
    dialogFrame:SetTitle(L["Add Food"])
    dialogFrame:SetLayout("Flow")
    dialogFrame:EnableResize(false)
    dialogFrame.frame:SetFrameStrata("DIALOG")
    dialogFrame.frame:Raise()

    setCloseOnEscPress(dialogFrame)

    -- Item details

    itemID = EasyReminders.AceGUI:Create("EditBox")
    itemID:SetLabel("Item ID: ")
    itemID:SetMaxLetters(10)
    itemID:SetCallback("OnEnterPressed", function(widget) WellFedDialog:FindItemByID() end)
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
    itemName:SetCallback("OnEnterPressed", function(widget) WellFedDialog:FindItemByName() end)
    dialogFrame:AddChild(itemName)


    local addItemButton = EasyReminders.AceGUI:Create("Button")
    dialogFrame:AddChild(addItemButton)
    addItemButton:SetFullWidth(true)
    addItemButton:SetWidth(580)
    addItemButton:SetText("Create Reminder")
    addItemButton:SetCallback("OnClick", function(widget) WellFedDialog:AddReminder() end)

    statusText = EasyReminders.AceGUI:Create("Label")
    statusText:SetText(" ")
    statusText:SetFullWidth(true)
    statusText:SetFont(EasyReminders.Font, 12, "")
    statusText:SetHeight(16)
    dialogFrame:AddChild(statusText)

    return mainFrame

end
