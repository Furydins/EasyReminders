EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.GroupTab = EasyReminders.UI.GroupTab or {}

local GroupTab = EasyReminders.UI.GroupTab

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

local Notice = {} 

Notice.ThreeHour = 180
Notice.TwoHour = 120
Notice.OneHour = 60
Notice.Start = 0


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

  local NoticeDropdown = {
    ["THREE_HOUR"] = L["Three Hours"],
    ["TWO_HOUR"] = L["Two Hours"],
    ["ONE_HOUR"] = L["One Hour"],
    ["START"] = L["At Start"],
  }

  if _G.IsInGuild() then
    local guildName = GetGuildInfo("player")
    AddRow(scrollBox, guildName)
  end

  local communities = C_Club.GetSubscribedClubs()
  for i, clubInfo in ipairs(communities) do 
    if clubInfo.clubType == Enum.ClubType.Character then
      AddRow(scrollBox, clubInfo.name)
    end
  end    

end

local function AddRow(scrollBox, name)

    local groupName = EasyReminders.AceGUI:Create("Label")
    groupName:SetText(name)
    groupName:SetFont(EasyReminders.Font, 12, "")
    groupName:SetWidth(440)
    scrollBox:AddChild(groupName)

    local settings = EasyReminders.charDB.group[name] and EasyReminders.charDB.group[name].settings or {}
    local notifications = EasyReminders.AceGUI:Create("Dropdown")
    notifications:SetMultiselect(true)
    notifications:SetList(NoticeDropdown)
    notifications:SetItemValue("THREE_HOUR", settings.THREE_HOUR or false)
    notifications:SetItemValue("TWO_HOUR", settings.TWO_HOUR or false)
    notifications:SetItemValue("ONE_HOUR", settings.ONE_HOUR or false)
    notifications:SetItemValue("START", settings.START or false)
    scrollBox:AddChild(notifications)
    notifications:SetCallback("OnValueChanged", function(_,_,key, checked)
        EasyReminders.charDB.group[name][key] = checked
    end)

end






