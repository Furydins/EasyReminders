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
local shownHolidays = {}

local function hasValue(tab, value)
    for k,v in pairs(tab) do
        if v == value then
            return true
        end
    end
    return false
end

local function cleanupOldEvents()
    for key,data in pairs(EasyReminders.charDB.groupShown) do
        if date.eventTime then
            local eventTime = date.eventTime
            local eventTable = {year = eventTime.year, month = eventTime.month, day = eventTime.monthDay, hour = eventTime.hour, min = eventTime.minute, sec = 0}
            local timeInMinutes = (_G.time(eventTable) - _G.GetServerTime()) / 60
            if timeInMinutes < -120 then
                EasyReminders.charDB.groupShown[key] = nil
            end
        end
    end
end

-- [0] = {["name"] = "holidayOne", ["holidayIndex"] = 100, ["duration"] = EasyReminders.Data.Duration.MONTHLY},
local function GetCalendarData(calendarEvent)

    local result = {}
    result.name = calendarEvent.title
    result.holidayIndex = nil
    result.duration = nil
    result.startTime = calendarEvent.startTime
    result.endTime = calendarEvent.endTime
    result.calendarType = calendarEvent.calendarType
    result.clubID = calendarEvent.clubID
    result.eventID = calendarEvent.eventID

    if calendarEvent.calendarType and calendarEvent.calendarType == "COMMUNITY_EVENT" then
        local clubInfo = C_Club.GetClubInfo(calendarEvent.clubID)
        result.name = calendarEvent.title .. " (" .. clubInfo.name .. ")"
        return result
    elseif calendarEvent.calendarType and calendarEvent.calendarType == "GUILD_EVENT" then
        local guildName = GetGuildInfo("player")
        result.name = calendarEvent.title .. " (" .. guildName .. ")"
        return result
    elseif calendarEvent.calendarType and calendarEvent.calendarType == "PLAYER" then
        result.name = calendarEvent.title .. " (Personal)"
        return result
    else 
        for i, data in pairs(EasyReminders.Data.Holidays) do
            if data and (data.holidayID == calendarEvent.eventID or hasValue(data.otherIds or {}, calendarEvent.eventID)) then
                result.name = calendarEvent.title
                result.holidayIndex = i
                result.duration = data.duration
                return result
            end
        end
    end
    return nil
end

local function GetEventKey(holidayData)
    local startTime = holidayData.startTime
    local endTime = holidayData.endTime

    local startKey = startTime and (
        (startTime.year or "") .. "-" ..
        (startTime.month or "") .. "-" ..
        (startTime.monthDay or "") .. " " ..
        (startTime.hour or "") .. ":" ..
        (startTime.minute or "")
    ) or ""

    local endKey = endTime and (
        (endTime.year or "") .. "-" ..
        (endTime.month or "") .. "-" ..
        (endTime.monthDay or "") .. " " ..
        (endTime.hour or "") .. ":" ..
        (endTime.minute or "")
    ) or ""

    return table.concat({
        holidayData.calendarType or "",
        holidayData.eventID or "",
        holidayData.clubID or "",
        holidayData.name or "",
        startKey,
        endKey,
    }, "|")
end

local function GetActiveHolidays()
    local activeEvents = {}
    local seenEvents = {}
    local today = C_DateAndTime.GetCurrentCalendarTime()
    local currentDateTime = _G.time({
        year = today.year,
        month = today.month,
        day = today.monthDay,
        hour = 0,
        min = 0,
        sec = 0,
    })
    local nextDate = _G.date("*t", currentDateTime + 86400)
    local nextMonthOffset = nextDate.month - today.month + ((nextDate.year - today.year) * 12)

    local datesToCheck = {
        { monthOffset = 0, day = today.monthDay },
        { monthOffset = nextMonthOffset, day = nextDate.day },
    }

    C_Calendar.OpenCalendar()

    for _, dateToCheck in ipairs(datesToCheck) do
        local numEvents = C_Calendar.GetNumDayEvents(dateToCheck.monthOffset, dateToCheck.day)
 
        for i = 1, numEvents do
            local calendarEvent = C_Calendar.GetDayEvent(dateToCheck.monthOffset, dateToCheck.day, i)
            local holidayData = GetCalendarData(calendarEvent)

            if holidayData then
                local eventKey = GetEventKey(holidayData)
                if not seenEvents[eventKey] then

                    if calendarEvent.calendarType == "GUILD_EVENT" or calendarEvent.calendarType == "COMMUNITY_EVENT" 
                    or calendarEvent.calendarType == "PLAYER" then
                        seenEvents[eventKey] = true
                        table.insert(activeEvents, holidayData)
                    elseif calendarEvent.calendarType == "HOLIDAY" then
                        local startTime = calendarEvent.startTime
                        local startTable = {
                            year = startTime.year,
                            month = startTime.month,
                            day = startTime.monthDay,
                            hour = startTime.hour,
                            min = startTime.minute,
                            sec = 0,
                        }
                        local endTime = calendarEvent.endTime
                        local endTable = {
                            year = endTime.year,
                            month = endTime.month,
                            day = endTime.monthDay,
                            hour = endTime.hour,
                            min = endTime.minute,
                            sec = 0,
                        }

                        if (_G.time(startTable) <= _G.GetServerTime() and _G.time(endTable) > _G.GetServerTime()) then
                            seenEvents[eventKey] = true
                            table.insert(activeEvents, holidayData)
                        end
                    end
                end
            end
        end
    end

    return activeEvents
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
    frame:SetTitle(L["Active Events"])
    frame:SetWidth(500)
    frame:SetHeight(150)
    frame:SetLayout("List")
    frame:SetAutoAdjustHeight(true)
    frame.frame:SetFrameStrata("MEDIUM")
     if not EasyReminders.globalDB.holidayLocation then
        frame:SetPoint("TOP", _G.UIParent, "CENTER", -300, -300)
    else
        frame:SetPoint(EasyReminders.globalDB.holidayLocation[1], 
                _G.UIParent, EasyReminders.globalDB.holidayLocation[3], EasyReminders.globalDB.holidayLocation[4], 
               EasyReminders.globalDB.holidayLocation[5])
    end
    frame.frame:SetMovable(true)
    HolidayWindow:StorePositon()
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
            HolidayWindow:StorePositon()
        end
    end)
  
    return frame
end

local function groupEventInScope(name, holidayData)
    local startTime = holidayData.startTime
    local startTable = {year = startTime.year, month = startTime.month, day = startTime.monthDay, hour = startTime.hour, min = startTime.minute, sec = 0}
    local endTime = holidayData.endTime
    local endTable = {year = endTime.year, month = endTime.month, day = endTime.monthDay, hour = endTime.hour, min = endTime.minute, sec = 0}

    local timeInMinutes = (_G.time(startTable) - _G.GetServerTime()) / 60

    local canShow = false

    local eventKey = GetEventKey(holidayData)

    if not EasyReminders.charDB.groupShown[eventKey] then
        EasyReminders.charDB.groupShown[eventKey] = {}
    end
    local shown = EasyReminders.charDB.groupShown[eventKey]

    if EasyReminders.charDB.group[name].settings.ONE_DAY and (timeInMinutes <= 1440 and timeInMinutes >= -60) and not shown.ONE_DAY then
       canShow = true
    end

    if EasyReminders.charDB.group[name].settings.THREE_HOUR and (timeInMinutes <= 180 and timeInMinutes >= -60) and not shown.THREE_HOUR then
       canShow = true
    end
    
    if EasyReminders.charDB.group[name].settings.TWO_HOUR and (timeInMinutes <= 120 and timeInMinutes >= -60) and not shown.TWO_HOUR then
        canShow = true
    end
    if EasyReminders.charDB.group[name].settings.ONE_HOUR and (timeInMinutes <= 60 and timeInMinutes >= -60) and not shown.ONE_HOUR then
        canShow = true
    end
    if EasyReminders.charDB.group[name].settings.QUARTER_HOUR and (timeInMinutes <= 15 and timeInMinutes >= -60)and not shown.QUARTER_HOUR then
        canShow = true
    end
    if EasyReminders.charDB.group[name].settings.START and (timeInMinutes <= 0 and timeInMinutes >= -60) and not shown.START then
        canShow = true
    end

    return canShow
   
end

local function GroupEventShown(holidayData)

    local eventKey = GetEventKey(holidayData)
    if not EasyReminders.charDB.groupShown[eventKey] then
        EasyReminders.charDB.groupShown[eventKey] = {}
    end

    local clubInfo = C_Club.GetClubInfo(holidayData.clubID) or {name = "Personal"}
    local name = clubInfo.name

    local startTime = holidayData.startTime
    local startTable = {year = startTime.year, month = startTime.month, day = startTime.monthDay, hour = startTime.hour, min = startTime.minute, sec = 0}
    local endTime = holidayData.endTime
    local endTable = {year = endTime.year, month = endTime.month, day = endTime.monthDay, hour = endTime.hour, min = endTime.minute, sec = 0}

    local timeInMinutes = (_G.time(startTable) - _G.GetServerTime()) / 60

    if EasyReminders.charDB.group[name].settings.ONE_DAY and (timeInMinutes <= 1440 and timeInMinutes >= -60) then
        EasyReminders.charDB.groupShown[eventKey].ONE_DAY = true
    end

    if EasyReminders.charDB.group[name].settings.THREE_HOUR and (timeInMinutes <= 180 and timeInMinutes >= -60) then
        EasyReminders.charDB.groupShown[eventKey].THREE_HOUR = true
    end
    
    if EasyReminders.charDB.group[name].settings.TWO_HOUR and (timeInMinutes <= 120 and timeInMinutes >= -60) then
        EasyReminders.charDB.groupShown[eventKey].TWO_HOUR = true
    end
    if EasyReminders.charDB.group[name].settings.ONE_HOUR and (timeInMinutes <= 60 and timeInMinutes >= -60) then
        EasyReminders.charDB.groupShown[eventKey].ONE_HOUR = true
    end
    if EasyReminders.charDB.group[name].settings.QUARTER_HOUR and (timeInMinutes <= 15 and timeInMinutes >= -60) then
        EasyReminders.charDB.groupShown[eventKey].QUARTER_HOUR = true
    end
    if EasyReminders.charDB.group[name].settings.START and (timeInMinutes <= 0 and timeInMinutes >= -60)  then
        EasyReminders.charDB.groupShown[eventKey].START = true
    end

    EasyReminders.charDB.groupShown[eventKey].eventTime = startTime
end

local function canShow(holidayData)

    if holidayData.calendarType == "GUILD_EVENT" then
        local name = GetGuildInfo("player")
        return groupEventInScope(name, holidayData)
    elseif holidayData.calendarType == "COMMUNITY_EVENT" then
        local clubInfo = C_Club.GetClubInfo(holidayData.clubID)
        return groupEventInScope(clubInfo.name, holidayData)
    elseif holidayData.calendarType == "PLAYER" then
        local name = "Personal"
        return groupEventInScope(name, holidayData)
    else
        local dismissDate = EasyReminders.charDB.holiday[holidayData.holidayIndex] and EasyReminders.charDB.holiday[holidayData.holidayIndex].dismissDate
        if not dismissDate then
            if EasyReminders.charDB.holiday[holidayData.holidayIndex] and EasyReminders.charDB.holiday[holidayData.holidayIndex].setting ~= EasyReminders.Data.HolidayMode.NEVER then
                return true
            else
                return false
            end
        end
    
        -- Parse the dismissDate
        local year, month, day, hour, min, sec = dismissDate:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
        local dismissTime = _G.time({year = tonumber(year), month = tonumber(month), day = tonumber(day), hour = tonumber(hour), min = tonumber(min), sec = tonumber(sec)})
    
        if EasyReminders.charDB.holiday[holidayData.holidayIndex].setting == EasyReminders.Data.HolidayMode.ONCE then
            -- Event start time
            local startTime = holidayData.startTime
            local startTable = {year = startTime.year, month = startTime.month, day = startTime.monthDay, hour = startTime.hour, min = startTime.minute, sec = 0}
            local startTimeSeconds = _G.time(startTable)

            if startTimeSeconds > dismissTime then 
                return true
            end
        end
    
        if EasyReminders.charDB.holiday[holidayData.holidayIndex].setting == EasyReminders.Data.HolidayMode.DAILY then
            local currentTime = _G.date(DATE_FORMAT)
            local c_year, c_month, c_day, c_hour, c_min, c_sec = currentTime:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
            local resetHour = resetTimes[CURRENT_REGION] or resetTimes["RetailUS"]
            local resetTime = _G.time({year = tonumber(c_year), month = tonumber(c_month), 
            day = tonumber(c_day), hour = tonumber(resetHour), min = 0, sec = 0})

            if resetTime > _G.GetServerTime() then -- if reset time is after now we want to use yesterday instead
                resetTime = resetTime - 86400
            end

            if resetTime > dismissTime then
                    return true
            end
        end
        return false
    end
end

function HolidayWindow:UpdateNotifications()
    if not _G.InCombatLockdown() and not C_ChallengeMode.IsChallengeModeActive() 
      and not C_PvP.IsMatchActive() and not (C_Secrets and C_Secrets.ShouldAurasBeSecret()) then

        local activeHolidays = GetActiveHolidays()

        local shouldShow = false

        frame:ReleaseChildren()

        shownHolidays = {}    
        local masterDismiss = EasyReminders.AceGUI:Create("Button")
        masterDismiss:SetText(L["Dismiss All"])
        masterDismiss:SetWidth(480)
        masterDismiss:SetCallback("OnClick", function(widget)
            HolidayWindow:DismissAll(shownHolidays)
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
                    if data.calendarType == "HOLIDAY" then
                        EasyReminders.charDB.holiday[data.holidayIndex] = EasyReminders.charDB.holiday[data.holidayIndex] or {}
                        EasyReminders.charDB.holiday[data.holidayIndex].dismissDate = _G.date(DATE_FORMAT)
                    else 
                        GroupEventShown(data)
                    end
                    group.frame:Hide()
                end)
                table.insert(shownHolidays, data)
                shouldShow = true
            end
        end

        if shouldShow then
            frame.frame:Show()
        end
    end

    cleanupOldEvents()
end

function HolidayWindow:DismissAll(currentHolidays)
    for i, data in pairs(currentHolidays) do
        if data.calendarType == "HOLIDAY" then
            EasyReminders.charDB.holiday[data.holidayIndex] = EasyReminders.charDB.holiday[data.holidayIndex] or {}
            EasyReminders.charDB.holiday[data.holidayIndex].dismissDate = _G.date(DATE_FORMAT)
        else
            GroupEventShown(data)
        end
    end
end

function HolidayWindow:HideHolidayWindow()
    if frame then
        frame.frame:Hide()
    end
end

function HolidayWindow:StorePositon()
    if EasyReminders.globalDB.holidayLocation == nil then
        EasyReminders.globalDB.holidayLocation = {}
    end
    point, relativeTo, relativePoint, offsetX, offsetY = frame:GetPoint()
    EasyReminders.globalDB.holidayLocation[1] = point
    EasyReminders.globalDB.holidayLocation[3] = relativePoint
    EasyReminders.globalDB.holidayLocation[4] = offsetX
    EasyReminders.globalDB.holidayLocation[5] = offsetY
end

function HolidayWindow:ResetReminders()
    EasyReminders.charDB.holiday = {}
    EasyReminders.charDB.groupShown = {}
end
