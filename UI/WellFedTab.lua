EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.WellFedTab = EasyReminders.UI.WellFedTab or {}

local WellFedTab = EasyReminders.UI.WellFedTab

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

EasyReminders.Filters = EasyReminders.Filters or {}

EasyReminders.Filters.food = {["MIDNIGHT"] = (_G.GetMaxLevelForExpansionLevel(_G.GetExpansionLevel()) or 90) >= 90,  
                   ["TWW"] = (_G.GetMaxLevelForExpansionLevel(_G.GetExpansionLevel()) or 80) < 90,
                   ["CUSTOM"] = true,
                   ["OTHER"] = true,}

-- function that draws the widgets for the first tab
function WellFedTab:Create(mainFrame, container)

  local addItemButton = EasyReminders.AceGUI:Create("Button")
  container:AddChild(addItemButton)
  addItemButton:SetText(L["Add Item"])
  addItemButton:SetCallback("OnClick", function(widget) EasyReminders.UI.WellFedDialog:Create(mainFrame) end)

  local filterText = EasyReminders.AceGUI:Create("Label")
  filterText:SetText(L["Filter:"])
  filterText:SetWidth(40)
  container:AddChild(filterText)

  local filterDropdown = EasyReminders.AceGUI:Create("Dropdown")
  filterDropdown:SetWidth(150)
  filterDropdown:SetList({
    [EasyReminders.Data.Expansions.MIDNIGHT] = L["Midnight"],
    [EasyReminders.Data.Expansions.TWW] = L["The War Within"],
    [EasyReminders.Data.Expansions.CUSTOM] = L["Custom"],
    [EasyReminders.Data.Expansions.OTHER] = L["Other Items"],
  })
  filterDropdown:SetMultiselect(true)
  filterDropdown:SetItemValue(EasyReminders.Data.Expansions.MIDNIGHT, EasyReminders.Filters.food.MIDNIGHT)
  filterDropdown:SetItemValue(EasyReminders.Data.Expansions.TWW, EasyReminders.Filters.food.TWW)
  filterDropdown:SetItemValue(EasyReminders.Data.Expansions.CUSTOM, EasyReminders.Filters.food.CUSTOM)
  filterDropdown:SetItemValue(EasyReminders.Data.Expansions.OTHER, EasyReminders.Filters.food.OTHER)
  container:AddChild(filterDropdown)
  filterDropdown:SetCallback("OnValueChanged", function(_,_,key, checked)
    EasyReminders.Filters.food[key] = checked
    WellFedTab:RebuildScrollBox()
  end)

  WellFedTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)

  WellFedTab:RebuildScrollBox()

end

function WellFedTab:RebuildScrollBox()
  local scrollBox = WellFedTab.ScrollBox
  scrollBox:ReleaseChildren()

  for key, data in pairs(EasyReminders.FoodCache)  do

    if not data.expansion then
      data.expansion = EasyReminders.Data.Expansions.OTHER
    end
    
    if EasyReminders.Filters.food[data.expansion] then

      local cacheEntry = EasyReminders.DataCache[data.itemID] or {}

      local itemName = cacheEntry[2] or C_Item.GetItemNameByID(data.itemID)
      local itemIcon = cacheEntry[3] or C_Item.GetItemIconByID(data.itemID)
      if data.otherIds then
        for key, otherID in pairs(data.otherIds) do
          C_Item.GetItemIconByID(otherID)
        end
      end

      ---
      local foodName = EasyReminders.AceGUI:Create("Label")
      foodName:SetText(itemName or L["Loading..."])
      foodName:SetFont(EasyReminders.Font, 12, "")
      foodName:SetWidth(440)
      foodName:SetImage(itemIcon)
      foodName:SetImageSize(16,16)
      scrollBox:AddChild(foodName)

      local activeDropdown = EasyReminders.AceGUI:Create("Dropdown")
      activeDropdown:SetWidth(150)
      activeDropdown:SetList({
        ["Raid"] = L["Raid"],
        ["Dungeon"] = L["Dungeon"],
        ["Delve"] = L["Delve"],
        ["Outside"] = L["Outside"],
      })

      EasyReminders.charDB.food[data.itemID] = EasyReminders.charDB.food[data.itemID] or {}
      activeDropdown:SetMultiselect(true)
      activeDropdown:SetItemValue("Raid", EasyReminders.charDB.food[data.itemID].raid or false)
      activeDropdown:SetItemValue("Dungeon", EasyReminders.charDB.food[data.itemID].dungeon or false)
      activeDropdown:SetItemValue("Delve", EasyReminders.charDB.food[data.itemID].delve or false)
      activeDropdown:SetItemValue("Outside", EasyReminders.charDB.food[data.itemID].outside or false)
      scrollBox:AddChild(activeDropdown)
      activeDropdown:SetCallback("OnValueChanged", function(_,_,key, checked)
        if "Raid" == key then
          EasyReminders.charDB.food[data.itemID].raid = checked
        elseif "Dungeon" == key then
          EasyReminders.charDB.food[data.itemID].dungeon = checked
        elseif "Delve" == key then
          EasyReminders.charDB.food[data.itemID].delve = checked
        elseif "Outside" == key then
          EasyReminders.charDB.food[data.itemID].outside = checked
        end
        EasyReminders.WellFedCheck:BuildTrackingList()
        EasyReminders:CheckBuffs()
      end)

      if data["canDelete"] then 

        local delete = EasyReminders.AceGUI:Create("Icon")
        delete:SetImage("Interface\\AddOns\\WoWPro\\Textures\\Delete")
        delete:SetImageSize(16,16)
        delete:SetWidth(20)
        delete:SetCallback("OnClick", function()
          WellFedTab:RemoveConfirm(data.itemID, itemName)
        end)
        scrollBox:AddChild(delete)
      end
    end

  end
end

function WellFedTab:RemoveConfirm(itemID, itemName)
    local dialogFrame = EasyReminders.AceGUI:Create("Window")
    dialogFrame:SetWidth(220)
    dialogFrame:SetHeight(100)
    dialogFrame:SetTitle("Confirm Removal")
    dialogFrame:SetLayout("Flow")
    dialogFrame:EnableResize(false)
    dialogFrame.frame:SetFrameStrata("DIALOG")
    dialogFrame.frame:Raise()

    local text =  EasyReminders.AceGUI:Create("Label")
    text:SetText(string.format(L["Are you sure you want to remove %s?"], itemName))
    text:SetFont(EasyReminders.Font, 12, "")
    dialogFrame:AddChild(text)

    local yes=EasyReminders.AceGUI:Create("Button")
    dialogFrame:AddChild(yes)
    yes:SetText("Yes")
    yes:SetWidth(90)
    yes:SetCallback("OnClick", function(widget) 
      WellFedTab:RemoveReminder(itemID) 
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

function WellFedTab:RemoveReminder(itemID)

  EasyReminders.globalDB.customFood[itemID] = nil
  EasyReminders.charDB.food[itemID] = nil

  if EasyReminders.Data.Food[itemID] then
    EasyReminders.FoodCache[itemID] = EasyReminders.Data.Food[itemID]
  else
    EasyReminders.FoodCache[itemID] = nil
  end

  EasyReminders.WellFedCheck:BuildTrackingList()
  EasyReminders:CheckBuffs()
  WellFedTab:RebuildScrollBox()
 
end






