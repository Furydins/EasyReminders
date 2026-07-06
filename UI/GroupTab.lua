EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.GroupTab = EasyReminders.UI.GroupTab or {}

local GroupTab = EasyReminders.UI.GroupTab

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

local Notice = {} 

Notice.OneDay = 1440
Notice.ThreeHour = 180
Notice.TwoHour = 120
Notice.OneHour = 60
Notice.QuarterHour = 15
Notice.Start = 0

local NoticeDropdown = {
  ["ONE_DAY"] = L["One Day"],
  ["THREE_HOUR"] = L["Three Hours"],
  ["TWO_HOUR"] = L["Two Hours"],
  ["ONE_HOUR"] = L["One Hour"],
  ["QUARTER_HOUR"] = L["15 Minutes"],
  ["START"] = L["At Start"],
}

local NoticeOrder = {
  "ONE_DAY",
  "THREE_HOUR",
  "TWO_HOUR",
  "ONE_HOUR",
  "QUARTER_HOUR",
  "START",
}

local function AddRow(scrollBox, name)

    local groupName = EasyReminders.AceGUI:Create("Label")
    groupName:SetText(name)
    groupName:SetFont(EasyReminders.Font, 12, "")
    groupName:SetWidth(440)
    scrollBox:AddChild(groupName)

    if not EasyReminders.charDB.group[name] then
      EasyReminders.charDB.group[name] = { ["settings"] = {} }
    end
    local settings = EasyReminders.charDB.group[name].settings
    local notifications = EasyReminders.AceGUI:Create("Dropdown")
    notifications:SetMultiselect(true)
    notifications:SetList(NoticeDropdown, NoticeOrder)
    notifications:SetItemValue("THREE_HOUR", settings.THREE_HOUR or false)
    notifications:SetItemValue("TWO_HOUR", settings.TWO_HOUR or false)
    notifications:SetItemValue("ONE_HOUR", settings.ONE_HOUR or false)
    notifications:SetItemValue("START", settings.START or false)
    notifications:SetItemValue("ONE_DAY", settings.ONE_DAY or false)
    notifications:SetItemValue("QUARTER_HOUR", settings.QUARTER_HOUR or false)
    scrollBox:AddChild(notifications)
    notifications:SetCallback("OnValueChanged", function(_,_,key, checked)
      settings[key] = checked
    end)

end

-- function that draws the widgets for the first tab
function GroupTab:Create(mainFrame, container)

  local titleContainer = EasyReminders.AceGUI:Create("SimpleGroup")
  titleContainer:SetFullWidth(true)
  titleContainer:SetLayout("Flow")  
  container:AddChild(titleContainer)

  GroupTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)

  GroupTab:RebuildScrollBox()

end

function GroupTab:RebuildScrollBox()
  local scrollBox = GroupTab.ScrollBox
  scrollBox:ReleaseChildren()

  if _G.IsInGuild() then
    local guildName = GetGuildInfo("player")
    AddRow(scrollBox, guildName)
  end

  local communities = C_Club.GetSubscribedClubs()
  for i, clubInfo in ipairs(communities) do 
    if clubInfo.clubType == Enum.ClubType.Character then
      AddRow(scrollBox, clubInfo.name, clubInfo.clubId)
    end
  end   
  
  -- Personal events
  AddRow(scrollBox, "Personal")

end








