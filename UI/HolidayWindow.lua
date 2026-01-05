EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.HolidayWindow = EasyReminders.UI.HolidayWindow or {}

local HolidayWindow = EasyReminders.UI.HolidayWindow

local frame

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

function HolidayWindow:CreateHolidayWindow()

    frame = EasyReminders.AceGUI:Create("Window")
    frame:SetWidth(128)
    frame:SetHeight(256)
    frame:SetLayout("List")
    frame:SetAutoAdjustHeight(true)
    frame.frame:SetFrameStrata("MEDIUM")
    frame:SetPoint("TOP", _G.UIParent, "CENTER", -300, -300)
    frame.frame:SetMovable(true)
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
        end
    end)
  
    return frame
end

local function canShow(holidayData)
    return true
end

function HolidayWindow:UpdateNotifications(activeHolidays)

    local shouldShow = false

    frame:ReleaseChildren()
    EasyReminders:RefreshData()

    local masterDismiss = EasyReminders.AceGUI:Create("Button")
    masterDismiss:SetText(L["Dismiss All"])
    masterDismiss:SetCallback("OnClick", function(_,_,value)
        HolidayWindow:DimissAll(activeHolidays)
        frame.Hide()
    end)
    frame:AddChild(masterDismiss)

    
    for i, data in pairs(activeHolidays) do
      if canShow(data) then 
        local group = EasyReminders.AceGUI:Create("SimpleGroup")
        group:SetLayout("flow")
        group:SetFullWidth(true)
        frame:AddChild(group)

        local holidayName = EasyReminders.AceGUI:Create("Label")
        holidayName:SetText( holidayData.name)
        holidayName:SetFont(EasyReminders.Font, 12, "")
        holidayName:SetWidth(440)
        group:AddChild(holidayName)


        local dismissButton = EasyReminders.AceGUI:Create("Button")
        dismissButton:SetText(L["Dismiss"])
        group:AddChild(dismissButton)
        holidayMode:SetCallback("OnClick", function(_,_,value)
            EasyReminders.charDB.holiday[data.holidayIndex] = EasyReminders.charDB.holiday[data.holidayIndex] or {}
            EasyReminders.charDB.holiday[data.holidayIndex].dismissDate = _G.date()
            group.frame.Hide()
        end)
      end
    end

    if shouldShow then
        frame.frame:Show()
    end
end

function HolidayWindow:DimissAll(activeHolidays)
    for i, data in pairs(activeHolidays) do
        EasyReminders.charDB.holiday[data.holidayIndex] = EasyReminders.charDB.holiday[data.holidayIndex] or {}
        EasyReminders.charDB.holiday[data.holidayIndex].dismissDate = _G.date()
    end
end
