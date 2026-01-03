EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.BuffDialog = EasyReminders.UI.BuffDialog or {}

local BuffDialog = EasyReminders.UI.BuffDialog

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

local dialogFrame
local buffID, buffName, buffIcon
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

function BuffDialog:FindSpellByID()
  local text = buffID:GetText()
  local id = tonumber(text)
  local name, icon
  if id then

    local spellInfo = C_Spell.GetSpellInfo(id)


    if not spellInfo or not spellInfo.name then
      name = "Not found"
    else
      name = spellInfo.name
    end

    buffName:SetText(name)

    if spellInfo then 
      buffName:SetImage(spellInfo.iconID)
    else
      buffName:SetImage(nil)
    end
  else
      buffID:SetText("invalid!")
      buffName:SetText("")
      buffName:SetImage(nil)
  end

end

local function validateID(id)
  if not tonumber(id) then
    return false
  else
    return true
  end
end

function BuffDialog:AddReminder()

  if not validateID(buffID:GetText()) then
    statusText:SetText("Invalid Item")
    return
  end

  local reminderData = {["buffID"] = tonumber(buffID:GetText())}

  reminderData["canDelete"] = true

  EasyReminders.globalDB.customBuffs[reminderData.buffID] = reminderData
  EasyReminders.BuffCache[reminderData.buffID] = reminderData
  EasyReminders.charDB.buff[reminderData.buffID] = nil

  EasyReminders.UI.BuffTab:RebuildScrollBox()

  statusText:SetText("Success!")
  dialogFrame:Hide()

end

function BuffDialog:Create(mainFrame)
    dialogFrame = EasyReminders.AceGUI:Create("Window")
    dialogFrame:SetWidth(600)
    dialogFrame:SetHeight(150)
    dialogFrame:SetTitle(L["Add Buff"])
    dialogFrame:SetLayout("Flow")
    dialogFrame:EnableResize(false)
    dialogFrame.frame:SetFrameStrata("DIALOG")
    dialogFrame.frame:Raise()

    setCloseOnEscPress(dialogFrame)

    -- Item details

    buffID = EasyReminders.AceGUI:Create("EditBox")
    buffID:SetLabel("Buff ID: ")
    buffID:SetMaxLetters(10)
    buffID:SetCallback("OnEnterPressed", function(widget) BuffDialog:FindSpellByID() end)
    dialogFrame:AddChild(buffID)

    buffIcon = EasyReminders.AceGUI:Create("Label")
    buffIcon:SetImageSize(16,16)
    buffIcon:SetWidth(20)
    buffIcon:SetHeight(16)
    buffIcon:SetPoint("TOPRIGHT", buffID.frame, "TOPLEFT", 5, 0)
    dialogFrame:AddChild(buffIcon)

    buffName = EasyReminders.AceGUI:Create("Label")
    buffName:SetText(" ")
    buffName:SetImageSize(16,16)
    buffName:SetWidth(250)
    buffName:SetFont(EasyReminders.Font, 12, "")
    buffName:SetHeight(16)
    buffName:SetPoint("TOPRIGHT", buffID.frame, "TOPLEFT", 5, 0)
    dialogFrame:AddChild(buffName)


    local addItemButton = EasyReminders.AceGUI:Create("Button")
    dialogFrame:AddChild(addItemButton)
    addItemButton:SetFullWidth(true)
    addItemButton:SetWidth(580)
    addItemButton:SetText("Create Reminder")
    addItemButton:SetCallback("OnClick", function(widget) BuffDialog:AddReminder() end)

    statusText = EasyReminders.AceGUI:Create("Label")
    statusText:SetText(" ")
    statusText:SetFullWidth(true)
    statusText:SetFont(EasyReminders.Font, 12, "")
    statusText:SetHeight(16)
    dialogFrame:AddChild(statusText)

    return mainFrame

end
