EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.RaidBuffTab = EasyReminders.UI.RaidBuffTab or {}

local RaidBuffTab = EasyReminders.UI.RaidBuffTab

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

-- function that draws the widgets for the first tab
function RaidBuffTab:Create(mainFrame, container)


  local titleContainer = EasyReminders.AceGUI:Create("SimpleGroup")
  titleContainer:SetFullWidth(true)
  titleContainer:SetLayout("Flow")  
  container:AddChild(titleContainer)

  local spacer  = EasyReminders.AceGUI:Create("Label")
  spacer:SetText("")
  spacer:SetWidth(10)
  titleContainer:AddChild(spacer)

  local buffTitle = EasyReminders.AceGUI:Create("Label")
  buffTitle:SetText(L["Buff"])
  buffTitle:SetWidth(440)
  titleContainer:AddChild(buffTitle)

  local personalTitle = EasyReminders.AceGUI:Create("Label")
  personalTitle:SetText(L["Personal"])
  personalTitle:SetWidth(50)
  titleContainer:AddChild(personalTitle)

  local raidTitle = EasyReminders.AceGUI:Create("Label")
  raidTitle:SetText(L["Raid"])
  raidTitle:SetWidth(50)
  titleContainer:AddChild(raidTitle)

  local dungeonTitle = EasyReminders.AceGUI:Create("Label")
  dungeonTitle:SetText(L["Dungeon"])
  dungeonTitle:SetWidth(50)
  titleContainer:AddChild(dungeonTitle)

  local pvpTitle = EasyReminders.AceGUI:Create("Label")
  pvpTitle:SetText(L["PvP"])
  pvpTitle:SetWidth(50)
  titleContainer:AddChild(pvpTitle)

  local delveTitle = EasyReminders.AceGUI:Create("Label")
  delveTitle:SetText(L["Delve"])
  delveTitle:SetWidth(50)
  titleContainer:AddChild(delveTitle)

  RaidBuffTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)

  RaidBuffTab:RebuildScrollBox()

end

function RaidBuffTab:RebuildScrollBox()
  local scrollBox = RaidBuffTab.ScrollBox
  scrollBox:ReleaseChildren()

  local _, class, _ = _G.UnitClass("player")

  for key, data in pairs(EasyReminders.Data.RaidBuffs)  do

    local spellInfo = C_Spell.GetSpellInfo(data.buffID)

    ---
    local buffName = EasyReminders.AceGUI:Create("Label")
    buffName:SetText((spellInfo and spellInfo.name) or L["Loading..."])
    buffName:SetFont(EasyReminders.Font, 12, "")
    buffName:SetWidth(440)
    buffName:SetImage((spellInfo and spellInfo.iconID) or nil)
    buffName:SetImageSize(16,16)
    scrollBox:AddChild(buffName)

    local personal
    if data.class == class then
        personal = EasyReminders.AceGUI:Create("CheckBox")
        personal:SetType("checkbox")
        personal:SetValue(false)
        personal:SetWidth(50)
        personal:SetValue((EasyReminders.charDB.raidBuff[data.itemID] and EasyReminders.charDB.raidBuff[data.itemID].outside) or false)
        personal:SetCallback("OnValueChanged", function(_,_,value)
        EasyReminders.charDB.raidBuff[data.buffID] = EasyReminders.charDB.raidBuff[data.buffID] or {}
        EasyReminders.charDB.raidBuff[data.buffID].personal = value
        EasyReminders.RaidBuffCheck:BuildTrackingList()
        EasyReminders:CheckBuffs()
        end)
        scrollBox:AddChild(personal)
    else
        personal = EasyReminders.AceGUI:Create("Label")
        personal:SetText(L["N/A"])
        personal:SetWidth(50)
        scrollBox:AddChild(personal)
    end


    local raid = EasyReminders.AceGUI:Create("CheckBox")
    raid:SetType("checkbox")
    raid:SetValue(false)
    raid:SetWidth(50)
    raid:SetValue((EasyReminders.charDB.raidBuff[data.buffID] and EasyReminders.charDB.raidBuff[data.buffID].raid) or false)
    scrollBox:AddChild(raid)
    raid:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.raidBuff[data.buffID] = EasyReminders.charDB.raidBuff[data.buffID] or {}
      EasyReminders.charDB.raidBuff[data.buffID].raid = value
      EasyReminders.RaidBuffCheck:BuildTrackingList()
      EasyReminders:CheckBuffs()
    end)

    local dungeon = EasyReminders.AceGUI:Create("CheckBox")
    dungeon:SetType("checkbox")
    dungeon:SetValue(false)
    dungeon:SetWidth(50)
    dungeon:SetValue((EasyReminders.charDB.raidBuff[data.buffID] and EasyReminders.charDB.raidBuff[data.buffID].dungeon) or false)
    dungeon:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.raidBuff[data.buffID] = EasyReminders.charDB.raidBuff[data.buffID] or {}
      EasyReminders.charDB.raidBuff[data.buffID].dungeon = value
      EasyReminders.RaidBuffCheck:BuildTrackingList()
      EasyReminders:CheckBuffs()
    end)
    scrollBox:AddChild(dungeon)

    local pvp = EasyReminders.AceGUI:Create("CheckBox")
    pvp:SetType("checkbox")
    pvp:SetValue(false)
    pvp:SetWidth(50)
    pvp:SetValue((EasyReminders.charDB.raidBuff[data.buffID] and EasyReminders.charDB.raidBuff[data.buffID].pvp) or false)
    pvp:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.raidBuff[data.buffID] = EasyReminders.charDB.raidBuff[data.buffID] or {}
      EasyReminders.charDB.raidBuff[data.buffID].pvp = value
      EasyReminders.RaidBuffCheck:BuildTrackingList()
      EasyReminders:CheckBuffs()
    end)
    scrollBox:AddChild(pvp)

    local delve = EasyReminders.AceGUI:Create("CheckBox")
    delve:SetType("checkbox")
    delve:SetValue(false)
    delve:SetWidth(50)
    delve:SetValue((EasyReminders.charDB.raidBuff[data.buffID] and EasyReminders.charDB.raidBuff[data.buffID].delve) or false)
    delve:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.raidBuff[data.buffID] = EasyReminders.charDB.raidBuff[data.buffID] or {}
      EasyReminders.charDB.raidBuff[data.buffID].delve = value
      EasyReminders.RaidBuffCheck:BuildTrackingList()
      EasyReminders:CheckBuffs()
    end)
    scrollBox:AddChild(delve)
  end
end







