EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.BuffTab = EasyReminders.UI.BuffTab or {}

local BuffTab = EasyReminders.UI.BuffTab

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

-- function that draws the widgets for the first tab
function BuffTab:Create(mainFrame, container)

  local addItemButton = EasyReminders.AceGUI:Create("Button")
  container:AddChild(addItemButton)
  addItemButton:SetText(L["Add Buff"])
  addItemButton:SetCallback("OnClick", function(widget) EasyReminders.UI.BuffDialog:Create(mainFrame) end)

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

  local raidTitle = EasyReminders.AceGUI:Create("Label")
  raidTitle:SetText(L["Raid"])
  raidTitle:SetWidth(50)
  titleContainer:AddChild(raidTitle)

  local dungeonTitle = EasyReminders.AceGUI:Create("Label")
  dungeonTitle:SetText(L["Dungeon"])
  dungeonTitle:SetWidth(50)
  titleContainer:AddChild(dungeonTitle)

  local delveTitle = EasyReminders.AceGUI:Create("Label")
  delveTitle:SetText(L["Delve"])
  delveTitle:SetWidth(50)
  titleContainer:AddChild(delveTitle)

  local outsideTitle = EasyReminders.AceGUI:Create("Label")
  outsideTitle:SetText(L["Outside"])
  outsideTitle:SetWidth(50)
  titleContainer:AddChild(outsideTitle)

  BuffTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)

  BuffTab:RebuildScrollBox()

end

function BuffTab:RebuildScrollBox()
  local scrollBox = BuffTab.ScrollBox
  scrollBox:ReleaseChildren()

  local _, class, _ = _G.UnitClass("player")

  for key, data in pairs(EasyReminders.BuffCache)  do
    if not data.class or data.class == class then
      local spellInfo = C_Spell.GetSpellInfo(data.buffID)

      ---
      local buffName = EasyReminders.AceGUI:Create("Label")
      buffName:SetText((spellInfo and spellInfo.name) or L["Loading..."])
      buffName:SetFont(EasyReminders.Font, 12, "")
      buffName:SetWidth(440)
      buffName:SetImage((spellInfo and spellInfo.iconID) or nil)
      buffName:SetImageSize(16,16)
      scrollBox:AddChild(buffName)

      local raid = EasyReminders.AceGUI:Create("CheckBox")
      raid:SetType("checkbox")
      raid:SetValue(false)
      raid:SetWidth(50)
      raid:SetValue((EasyReminders.charDB.buff[data.buffID] and EasyReminders.charDB.buff[data.buffID].raid) or false)
      scrollBox:AddChild(raid)
      raid:SetCallback("OnValueChanged", function(_,_,value)
        EasyReminders.charDB.buff[data.buffID] = EasyReminders.charDB.buff[data.buffID] or {}
        EasyReminders.charDB.buff[data.buffID].raid = value
        EasyReminders.BuffCheck:BuildTrackingList()
        EasyReminders:CheckBuffs()
      end)

      local dungeon = EasyReminders.AceGUI:Create("CheckBox")
      dungeon:SetType("checkbox")
      dungeon:SetValue(false)
      dungeon:SetWidth(50)
      dungeon:SetValue((EasyReminders.charDB.buff[data.buffID] and EasyReminders.charDB.buff[data.buffID].dungeon) or false)
      dungeon:SetCallback("OnValueChanged", function(_,_,value)
        EasyReminders.charDB.buff[data.buffID] = EasyReminders.charDB.buff[data.buffID] or {}
        EasyReminders.charDB.buff[data.buffID].dungeon = value
        EasyReminders.BuffCheck:BuildTrackingList()
        EasyReminders:CheckBuffs()
      end)
      scrollBox:AddChild(dungeon)

      local delve = EasyReminders.AceGUI:Create("CheckBox")
      delve:SetType("checkbox")
      delve:SetValue(false)
      delve:SetWidth(50)
      delve:SetValue((EasyReminders.charDB.buff[data.buffID] and EasyReminders.charDB.buff[data.buffID].delve) or false)
      delve:SetCallback("OnValueChanged", function(_,_,value)
        EasyReminders.charDB.buff[data.buffID] = EasyReminders.charDB.buff[data.buffID] or {}
        EasyReminders.charDB.buff[data.buffID].delve = value
        EasyReminders.BuffCheck:BuildTrackingList()
        EasyReminders:CheckBuffs()
      end)
      scrollBox:AddChild(delve)

      local outside = EasyReminders.AceGUI:Create("CheckBox")
      outside:SetType("checkbox")
      outside:SetValue(false)
      outside:SetWidth(50)
      outside:SetValue((EasyReminders.charDB.buff[data.buffID] and EasyReminders.charDB.buff[data.buffID].outside) or false)
      outside:SetCallback("OnValueChanged", function(_,_,value)
        EasyReminders.charDB.buff[data.buffID] = EasyReminders.charDB.buff[data.buffID] or {}
        EasyReminders.charDB.buff[data.buffID].outside = value
        EasyReminders.BuffCheck:BuildTrackingList()
        EasyReminders:CheckBuffs()
      end)
      scrollBox:AddChild(outside)

      if data["canDelete"] then 

        local delete = EasyReminders.AceGUI:Create("Icon")
        delete:SetImage("Interface\\AddOns\\WoWPro\\Textures\\Delete")
        delete:SetImageSize(16,16)
        delete:SetWidth(20)
        delete:SetCallback("OnClick", function()
          BuffTab:RemoveConfirm(data.buffID,  spellInfo.name)
        end)
        scrollBox:AddChild(delete)
    end
    end
  end
end
function BuffTab:RemoveConfirm(buffID, buffName)
    local dialogFrame = EasyReminders.AceGUI:Create("Window")
    dialogFrame:SetWidth(220)
    dialogFrame:SetHeight(100)
    dialogFrame:SetTitle("Confirm Removal")
    dialogFrame:SetLayout("Flow")
    dialogFrame:EnableResize(false)
    dialogFrame.frame:SetFrameStrata("DIALOG")
    dialogFrame.frame:Raise()

    local text =  EasyReminders.AceGUI:Create("Label")
    text:SetText(string.format(L["Are you sure you want to remove %s?"], buffName))
    text:SetFont(EasyReminders.Font, 12, "")
    dialogFrame:AddChild(text)

    local yes=EasyReminders.AceGUI:Create("Button")
    dialogFrame:AddChild(yes)
    yes:SetText("Yes")
    yes:SetWidth(90)
    yes:SetCallback("OnClick", function(widget) 
      BuffTab:RemoveReminder(buffID) 
      dialogFrame:Hide()
    end)

    local no=EasyReminders.AceGUI:Create("Button")
    dialogFrame:AddChild(no)
    no:SetWidth(90)
    no:SetText("No")
    no:SetCallback("OnClick", function(widget) 
      dialogFrame:Hide()
    end)

end

function BuffTab:RemoveReminder(buffID)


  EasyReminders.globalDB.customBuffs[buffID] = nil
  EasyReminders.charDB.buff[buffID] = nil

  if EasyReminders.Data.Buffs[buffID] then
    EasyReminders.BuffCache[buffID] = EasyReminders.Data.Buff[buffD]
  else
    EasyReminders.BuffCache[buffID] = nil
  end

  EasyReminders.BuffCheck:BuildTrackingList()
  EasyReminders:CheckBuffs()
  BuffTab:RebuildScrollBox()
 
end




