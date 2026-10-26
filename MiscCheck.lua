EasyReminders.MiscCheck = EasyReminders.MiscCheck or {}

local MiscCheck = EasyReminders.MiscCheck

local frame

function MiscCheck:CheckReroll()
  if EasyReminders.charDB.rerollKey and EasyReminders.RETAIL then
    local info
    C_Timer.After(0.15, function()
        -- Example: use C_ChallengeMode.GetCompletionInfo() if available
        -- (function names vary by patch; check your client's API or wowpedia/warcraft.wiki)
        info = C_ChallengeMode.GetChallengeCompletionInfo()

        if (not info or not info.mapChallengeModeID or info.mapChallengeModeID == 0) and C_MythicPlus and C_MythicPlus.RequestMapInfo then
            -- ask the client to load map info, then try again
            C_MythicPlus.RequestMapInfo()
            C_Timer.After(0.25, function()
                info = C_ChallengeMode.GetChallengeCompletionInfo()
            end)
        end
    end)
    if into and info.mapChallengeModeID and info.mapChallengeModeID ~= 0 then
        local keylevel =  C_MythicPlus.GetOwnedKeystoneLevel()
        if keyLevel <= info.level and info.onTime then
            MiscCheck:ShowPopup(L["Reroll Key Reminder"], L["You have completed a Mythic+ dungeon. Remember to reroll your key!"])
        end
    end
  end
end

function MiscCheck:ShowPopup(title, message)
  if not frame then
    frame = EasyReminders.AceGUI:Create("Window")
    frame:SetTitle(title)
    frame:SetWidth(480)
    frame:SetHeight(90)
    frame:SetLayout("List")
    frame:EnableResize(false)
    frame.frame:SetFrameStrata("MEDIUM")
    if not EasyReminders.globalDB.miscLocation then
      frame:SetPoint("TOP", _G.UIParent, "CENTER", -38, 300)
    else
      frame:SetPoint(EasyReminders.globalDB.miscLocation[1], 
              _G.UIParent, EasyReminders.globalDB.miscLocation[3], EasyReminders.globalDB.miscLocation[4], 
              EasyReminders.globalDB.miscLocation[5])
    end
    frame.frame:SetMovable(true)
    MiscCheck:StorePositon()
    frame.frame:Hide()

    --- drag suport

    frame.frame:SetScript("OnMouseDown", function(this, button)
      if button == "LeftButton" and not EasyReminders.globalDB.lock then
          this:StartMoving()
      end
    end)
    frame.frame:SetScript("OnMouseUp", function(this, button)
      if button == "LeftButton" then
          this:StopMovingOrSizing()
          MiscCheck:StorePositon()
      end
    end)

  end

  frame:ReleaseChildren()
  local group = EasyReminders.AceGUI:Create("SimpleGroup")
  group:SetLayout("flow")
  group:SetFullWidth(true)
  frame:AddChild(group)
  
  local reminderText = EasyReminders.AceGUI:Create("Label")
  reminderText:SetText(message)
  reminderText:SetFont(EasyReminders.Font, 12, "")
  reminderText:SetFullWidth(true)
  group:AddChild(reminderText)


  local dismissButton = EasyReminders.AceGUI:Create("Button")
  dismissButton:SetText(L["Dismiss"])
  dismissButton:SetFullWidth(true)
  group:AddChild(dismissButton)
  dismissButton:SetCallback("OnClick", function(widget)
      frame:Hide()
  end)
  frame:Show()

  return frame
end

function MiscCheck:StorePositon()
  if EasyReminders.globalDB.miscLocation == nil then
      EasyReminders.globalDB.miscLocation = {}
  end
  point, relativeTo, relativePoint, offsetX, offsetY = frame:GetPoint()
  EasyReminders.globalDB.miscLocation[1] = point
  EasyReminders.globalDB.miscLocation[3] = relativePoint
  EasyReminders.globalDB.miscLocation[4] = offsetX
  EasyReminders.globalDB.miscLocation[5] = offsetY
end

function EasyReminders.MiscCheck:SimulateFailedMythicPlusCompletion()
  MiscCheck:CheckReroll()
end

function EasyReminders.MiscCheck:SimulateSuccessfulMythicPlusCompletion()
  MiscCheck:ShowPopup(L["Reroll Key Reminder"], L["You have completed a Mythic+ dungeon. Remember to reroll your key!"])
end

function EasyReminders.MiscCheck:GetFramePosition()
  return frame:GetPoint()
end

