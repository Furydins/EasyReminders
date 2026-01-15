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

      local activeDropdown = EasyReminders.AceGUI:Create("Dropdown")
      activeDropdown:SetWidth(150)
      activeDropdown:SetList({
        ["Raid"] = L["Raid"],
        ["Dungeon"] = L["Dungeon"],
        ["Delve"] = L["Delve"],
        ["Outside"] = L["Outside"],
      })

      EasyReminders.charDB.buff[data.buffID] = EasyReminders.charDB.buff[data.buffID] or {}
      activeDropdown:SetMultiselect(true)
      activeDropdown:SetItemValue("Raid", EasyReminders.charDB.buff[data.buffID].raid or false)
      activeDropdown:SetItemValue("Dungeon", EasyReminders.charDB.buff[data.buffID].dungeon or false)
      activeDropdown:SetItemValue("Delve", EasyReminders.charDB.buff[data.buffID].delve or false)
      activeDropdown:SetItemValue("Outside", EasyReminders.charDB.buff[data.buffID].outside or false)
      scrollBox:AddChild(activeDropdown)
      activeDropdown:SetCallback("OnValueChanged", function(_,_,key, checked)
        if "Raid" == key then
          EasyReminders.charDB.buff[data.buffID].raid = checked
        elseif "Dungeon" == key then
          EasyReminders.charDB.buff[data.buffID].dungeon = checked
        elseif "Delve" == key then
          EasyReminders.charDB.buff[data.buffID].delve = checked
        elseif "Outside" == key then
          EasyReminders.charDB.buff[data.buffID].outside = checked
        end
        EasyReminders.BuffCheck:BuildTrackingList()
        EasyReminders:CheckBuffs()
      end)

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




