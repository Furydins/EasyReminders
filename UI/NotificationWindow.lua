EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.NotificationWindow = EasyReminders.UI.NotificationWindow or {}

local NotificationWindow = EasyReminders.UI.NotificationWindow

local frame

function NotificationWindow:CreateNotificationWindow()

    frame = EasyReminders.AceGUI:Create("SimpleGroup")
    frame:SetWidth(64)
    frame:SetHeight(256)
    frame:SetLayout("List")
    frame:SetAutoAdjustHeight(true)
    frame.frame:SetFrameStrata(HIGH)
    frame:SetPoint("TOP", UIParent, "CENTER", -300, 300)
  
    return frame
end

function NotificationWindow:UpdateNotifications(missingBuffs)
    frame:ReleaseChildren()
    EasyReminders.UI.ConsumablesTab:RefreshData()
    
    for buffID, itemID in pairs(missingBuffs) do
        EasyReminders:Print("Displaying buff:" .. buffID .. "::", itemID)
        itemData = EasyReminders.DataCache[itemID]

        local icon = EasyReminders.AceGUI:Create("Label")
        icon:SetImage(itemData[3])
        icon:SetImageSize(64,64)
        frame:AddChild(icon)

    end

end


