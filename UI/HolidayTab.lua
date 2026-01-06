EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.HolidayTab = EasyReminders.UI.HolidayTab or {}

local HolidayTab = EasyReminders.UI.HolidayTab

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

-- function that draws the widgets for the first tab
function HolidayTab:Create(mainFrame, container)

  local titleContainer = EasyReminders.AceGUI:Create("SimpleGroup")
  titleContainer:SetFullWidth(true)
  titleContainer:SetLayout("Flow")  
  container:AddChild(titleContainer)

  local spacer  = EasyReminders.AceGUI:Create("Label")
  spacer:SetText("")
  spacer:SetWidth(10)
  titleContainer:AddChild(spacer)

  local buffTitle = EasyReminders.AceGUI:Create("Label")
  buffTitle:SetText(L["Holiday Name"])
  buffTitle:SetWidth(440)
  titleContainer:AddChild(buffTitle)

  local optionsTitle = EasyReminders.AceGUI:Create("Label")
  optionsTitle:SetText(L["Options"])
  optionsTitle:SetWidth(50)
  titleContainer:AddChild(optionsTitle)

  HolidayTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)

  HolidayTab:RebuildScrollBox()

end

function HolidayTab:RebuildScrollBox()
  local scrollBox = HolidayTab.ScrollBox
  scrollBox:ReleaseChildren()

  local holidayModeDropdown = {
    [EasyReminders.Data.HolidayMode.NEVER] = L["Never"],
    [EasyReminders.Data.HolidayMode.ONCE] = L["Once per year"],
    [EasyReminders.Data.HolidayMode.DAILY] = L["Once per event"],
  }

  for i=1,#EasyReminders.Data.Holidays do
      local holidayData = EasyReminders.Data.Holidays[i]

      ---
      local holidayName = EasyReminders.AceGUI:Create("Label")
      holidayName:SetText( holidayData.name)
      holidayName:SetFont(EasyReminders.Font, 12, "")
      holidayName:SetWidth(440)
      scrollBox:AddChild(holidayName)

      local holidayMode = EasyReminders.AceGUI:Create("Dropdown")
      holidayMode:SetList(holidayModeDropdown, {EasyReminders.Data.HolidayMode.NEVER, EasyReminders.Data.HolidayMode.ONCE, EasyReminders.Data.HolidayMode.DAILY})
      holidayMode:SetValue(EasyReminders.charDB.holiday[i] or EasyReminders.Data.HolidayMode.NEVER)
      scrollBox:AddChild(holidayMode)
      holidayMode:SetCallback("OnValueChanged", function(_,_,value)
        EasyReminders.charDB.holiday[i] = EasyReminders.charDB.holiday[i] or {}
        EasyReminders:Print("Holiday setting:", EasyReminders.charDB.holiday[i])
        EasyReminders.charDB.holiday[i].setting = value
        -- EasyReminders.HolidayCheck:BuildTrackingList()
        -- EasyReminders:CheckHolidays()
      end)

    
    end
end






