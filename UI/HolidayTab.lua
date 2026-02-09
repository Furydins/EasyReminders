EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.HolidayTab = EasyReminders.UI.HolidayTab or {}

local HolidayTab = EasyReminders.UI.HolidayTab

EasyReminders.Filters = EasyReminders.Filters or {}
EasyReminders.Filters.holidays = EasyReminders.Filters.holidays or {}

EasyReminders.Filters.holidays = {["MAJOR"] = true,  
                   ["MICRO"] = true,  
                   ["BRAWL"] = true,
                   ["TIMEWALKING"] = true,
                   ["SKYRIDING"] = true,
                   ["OTHER"] = true,}


local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

-- function that draws the widgets for the first tab
function HolidayTab:Create(mainFrame, container)

  local titleContainer = EasyReminders.AceGUI:Create("SimpleGroup")
  titleContainer:SetFullWidth(true)
  titleContainer:SetLayout("Flow")  
  container:AddChild(titleContainer)

local filterDropdown = EasyReminders.AceGUI:Create("Dropdown")
  filterDropdown:SetWidth(150)
  filterDropdown:SetList({
    [EasyReminders.Data.HolidayCategories.MAJOR] = L["Major Holidays"],
    [EasyReminders.Data.HolidayCategories.MICRO] = L["Micro Holidays"],
    [EasyReminders.Data.HolidayCategories.BRAWL] = L["Brawls"],
    [EasyReminders.Data.HolidayCategories.TIMEWALKING] = L["Timewalking"],
    [EasyReminders.Data.HolidayCategories.SKYRIDING] = L["Skyriding Cups"],
    [EasyReminders.Data.HolidayCategories.OTHER] = L["Other Events"],
  })
  filterDropdown:SetMultiselect(true)
  filterDropdown:SetItemValue(EasyReminders.Data.HolidayCategories.MAJOR, EasyReminders.Filters.holidays.MAJOR)
  filterDropdown:SetItemValue(EasyReminders.Data.HolidayCategories.MICRO, EasyReminders.Filters.holidays.MICRO)
  filterDropdown:SetItemValue(EasyReminders.Data.HolidayCategories.BRAWL, EasyReminders.Filters.holidays.BRAWL)
  filterDropdown:SetItemValue(EasyReminders.Data.HolidayCategories.TIMEWALKING, EasyReminders.Filters.holidays.TIMEWALKING)
  filterDropdown:SetItemValue(EasyReminders.Data.HolidayCategories.SKYRIDING, EasyReminders.Filters.holidays.SKYRIDING)
  filterDropdown:SetItemValue(EasyReminders.Data.HolidayCategories.OTHER, EasyReminders.Filters.holidays.OTHER)
  container:AddChild(filterDropdown)
  filterDropdown:SetCallback("OnValueChanged", function(_,_,key, checked)
    EasyReminders.Filters.holidays[key] = checked
    HolidayTab:RebuildScrollBox()
  end)

  HolidayTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)

  HolidayTab:RebuildScrollBox()

end

function HolidayTab:RebuildScrollBox()
  local scrollBox = HolidayTab.ScrollBox
  scrollBox:ReleaseChildren()

  local holidayModeDropdown = {
    [EasyReminders.Data.HolidayMode.NEVER] = L["Never"],
    [EasyReminders.Data.HolidayMode.ONCE] = L["Once per event"],
    [EasyReminders.Data.HolidayMode.DAILY] = L["Once per day"],
  }

  for i=1,#EasyReminders.Data.Holidays do

       local holidayData = EasyReminders.Data.Holidays[i]
       if EasyReminders.Filters.holidays[holidayData.category] then

        ---
        local holidayName = EasyReminders.AceGUI:Create("Label")
        holidayName:SetText( holidayData.name)
        holidayName:SetFont(EasyReminders.Font, 12, "")
        holidayName:SetWidth(440)
        scrollBox:AddChild(holidayName)

        local setting = EasyReminders.charDB.holiday[i] and EasyReminders.charDB.holiday[i].setting
        local holidayMode = EasyReminders.AceGUI:Create("Dropdown")
        holidayMode:SetList(holidayModeDropdown, {EasyReminders.Data.HolidayMode.NEVER, EasyReminders.Data.HolidayMode.ONCE, EasyReminders.Data.HolidayMode.DAILY})
        holidayMode:SetValue(setting or EasyReminders.Data.HolidayMode.NEVER)
        scrollBox:AddChild(holidayMode)
        holidayMode:SetCallback("OnValueChanged", function(_,_,value)
          EasyReminders.charDB.holiday[i] = EasyReminders.charDB.holiday[i] or {}
          EasyReminders.charDB.holiday[i].setting = value
        end)
      end

    
    end
end






