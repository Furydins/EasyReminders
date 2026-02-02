EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.NotificationWindow = EasyReminders.UI.NotificationWindow or {}

local NotificationWindow = EasyReminders.UI.NotificationWindow

local frame

function NotificationWindow:CreateNotificationWindow()

    frame = EasyReminders.AceGUI:Create("SimpleGroup")
    NotificationWindow:ChangeOrientation(EasyReminders.globalDB.orientation)
    frame.frame:SetFrameStrata("MEDIUM")
    frame:SetPoint("TOP", _G.UIParent, "CENTER", -300, 300)
    frame.frame:SetMovable(true)

    --- drag suport

   frame.frame:SetScript("OnMouseDown", function(this, button)
        if button == "LeftButton" and not EasyReminders.globalDB.lock then
            this:StartMoving()
        end
    end)
    frame.frame:SetScript("OnMouseUp", function(this, button)
        if button == "LeftButton" then
            this:StopMovingOrSizing()
        end
    end)
  
    return frame
end

function NotificationWindow:UpdateNotifications(missingBuffs)

    local optionsdb = EasyReminders.globalDB
    local toShow = 0

    frame:ReleaseChildren()

    if optionsdb.anchor then
      local anchor = EasyReminders.AceGUI:Create("Label")
      anchor:SetImage("Interface\\Icons\\Spell_holy_borrowedtime")
      anchor:SetImageSize(64,64)
      anchor:SetWidth(64)
      frame:AddChild(anchor)
    end
    
    for buffID, iconID in pairs(missingBuffs) do
        itemData = EasyReminders.DataCache[itemID]

        local icon = EasyReminders.AceGUI:Create("Label")
        icon:SetImage(iconID)
        icon:SetImageSize(64,64)
        icon:SetWidth(64)
        frame:AddChild(icon)
        toShow = toShow + 1
    end

    if EasyReminders.globalDB.orientation == "HORIZONTAL" then
        frame:SetWidth( math.max((toShow + (optionsdb.anchor and 1 or 0)) * 67, 256) )
    end
end

function NotificationWindow:ChangeOrientation(orientation)
    if orientation == "HORIZONTAL" then
        frame:SetWidth(512)
        frame:SetHeight(64)
        frame:SetLayout("Flow")
        frame:SetAutoAdjustHeight(false)
    else
        frame:SetWidth(64)
        frame:SetHeight(256)
        frame:SetLayout("List")
        frame:SetAutoAdjustHeight(true)
    end
end

