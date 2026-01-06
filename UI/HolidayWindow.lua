EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.HolidayWindow = EasyReminders.UI.HolidayWindow or {}

local HolidayWindow = EasyReminders.UI.HolidayWindow

local DATE_FORMAT = "%Y-%m-%d %H:%M:%S"

local CURRENT_REGION = _G.GetCurrentRegion()

local resetTimes = {
    ["RetailUS"] = 04,
    ["RetailEU"] = 15, 
    ["RetailKR"] = 23,
    ["RetailTW"] = 23,
    ["RetailCN"] = 23,
}

local frame

-- [0] = {["name"] = "holidayOne", ["holidayIndex"] = 100, ["duration"] = EasyReminders.Data.Duration.MONTHLY},
local function GetCalendarData(calendarEvent)
    for i, data in pairs(EasyReminders.Data.Holidays) do
        if data.holidayID == calendarEvent.eventID then
            local result = {}
            result.name = calendarEvent.title
            result.holidayIndex = i
            result.duration = data.duration
            return result
        end
    end
    return nil

end


local function GetActiveHolidays()
    activeHolidays = { }
	local today = C_DateAndTime.GetCurrentCalendarTime()
	local month, day, year = today.month, today.monthDay, today.year
    C_Calendar.OpenCalendar()
	local numEvents = C_Calendar.GetNumDayEvents(0, day)

	for i = 1, numEvents do
		local calendarEvent = C_Calendar.GetDayEvent(0, day, i)

		if calendarEvent.calendarType == "HOLIDAY" then
			table.insert(activeHolidays, GetCalendarData(calendarEvent))
		end
	end
    return activeHolidays
end

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
    frame:SetTitle(L["Active Holidays"])
    frame:SetWidth(500)
    frame:SetHeight(150)
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
    local dismissDate = EasyReminders.charDB.holiday[holidayData.holidayIndex] and EasyReminders.charDB.holiday[holidayData.holidayIndex].dismissDate
    if not dismissDate then
        return true
    end

    local currentTime = _G.date(DATE_FORMAT)
    local c_year, c_month, c_day, c_hour, c_min, c_sec = currentTime:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
    local resetHour = resetTimes[CURRENT_REGION] or resetTimes["RetailUS"]
    local resetTime = _G.time({year = tonumber(c_year), month = tonumber(c_month), 
        day = tonumber(c_day), hour = tonumber(resetHour), min = 0, sec = 0})

    if resetTime > _G.GetServerTime() then -- if reset time is after now we want to use yesterday instead
        resetTime = resetTime - 86400
    end
    
    -- Parse the dismissDate
    local year, month, day, hour, min, sec = dismissDate:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
    local dismissTime = _G.time({year = tonumber(year), month = tonumber(month), day = tonumber(day), hour = tonumber(hour), min = tonumber(min), sec = tonumber(sec)})
    local currentTime = _G.GetServerTime() 
    local diffSeconds = currentTime - dismissTime

    -- Calculate days and hours
    local days = math.floor(diffSeconds / 86400)

    if EasyReminders.charDB.holiday[holidayData.holidayIndex].setting == EasyReminders.Data.HolidayMode.ONCE then
        if days > holidayData.duration then 
            return true
        end
    end
   
    if EasyReminders.charDB.holiday[holidayData.holidayIndex].setting == EasyReminders.Data.HolidayMode.DAILY then
       if resetTime > dismissTime then
            return true
       end
    end
    return false
end

function HolidayWindow:UpdateNotifications()
    local activeHolidays = GetActiveHolidays()

    local shouldShow = false

    frame:ReleaseChildren()
    EasyReminders:RefreshData()

    local masterDismiss = EasyReminders.AceGUI:Create("Button")
    masterDismiss:SetText(L["Dismiss All"])
    masterDismiss:SetWidth(480)
    masterDismiss:SetCallback("OnClick", function(widget)
        HolidayWindow:DimissAll(activeHolidays)
        frame.frame:Hide()
    end)
    frame:AddChild(masterDismiss)

    
    for i, data in pairs(activeHolidays) do
      if canShow(data) then 
        local group = EasyReminders.AceGUI:Create("SimpleGroup")
        group:SetLayout("flow")
        group:SetFullWidth(true)
        frame:AddChild(group)

        local holidayName = EasyReminders.AceGUI:Create("Label")
        holidayName:SetText( data.name)
        holidayName:SetFont(EasyReminders.Font, 12, "")
        holidayName:SetWidth(300)
        group:AddChild(holidayName)


        local dismissButton = EasyReminders.AceGUI:Create("Button")
        dismissButton:SetText(L["Dismiss"])
        dismissButton:SetWidth(140)
        group:AddChild(dismissButton)
        dismissButton:SetCallback("OnClick", function(widget)
            EasyReminders.charDB.holiday[data.holidayIndex] = EasyReminders.charDB.holiday[data.holidayIndex] or {}
            EasyReminders.charDB.holiday[data.holidayIndex].dismissDate = _G.date(DATE_FORMAT)
            group.frame:Hide()
        end)
        shouldShow = true
      end
    end

    if shouldShow then
        frame.frame:Show()
    end
end

function HolidayWindow:DimissAll(activeHolidays)
    for i, data in pairs(activeHolidays) do
        EasyReminders.charDB.holiday[data.holidayIndex] = EasyReminders.charDB.holiday[data.holidayIndex] or {}
        EasyReminders.charDB.holiday[data.holidayIndex].dismissDate = _G.date(DATE_FORMAT)
    end
end
