EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.WellFedTab = EasyReminders.UI.WellFedTab or {}

local WellFedTab = EasyReminders.UI.WellFedTab
local dataCache = EasyReminders.DataCache

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

-- function that draws the widgets for the first tab
function WellFedTab:Create(mainFrame, container)

  local addItemButton = EasyReminders.AceGUI:Create("Button")
  container:AddChild(addItemButton)
  addItemButton:SetText(L["Add Item"])
  addItemButton:SetCallback("OnClick", function(widget) EasyReminders.UI.WellFedDialog:Create(mainFrame) end)

  local titleContainer = EasyReminders.AceGUI:Create("SimpleGroup")
  titleContainer:SetFullWidth(true)
  titleContainer:SetLayout("Flow")  
  container:AddChild(titleContainer)

  local spacer  = EasyReminders.AceGUI:Create("Label")
  spacer:SetText("")
  spacer:SetWidth(10)
  titleContainer:AddChild(spacer)

  local potionTitle = EasyReminders.AceGUI:Create("Label")
  potionTitle:SetText(L["Item"])
  potionTitle:SetWidth(230)
  titleContainer:AddChild(potionTitle)

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

  local outsideTitle = EasyReminders.AceGUI:Create("Label")
  outsideTitle:SetText(L["Outside"])
  outsideTitle:SetWidth(50)
  titleContainer:AddChild(outsideTitle)

  WellFedTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)

  WellFedTab:RebuildScrollBox()

end

function WellFedTab:RebuildScrollBox()
  local scrollBox = WellFedTab.ScrollBox
  scrollBox:ReleaseChildren()

  for key, data in pairs(EasyReminders.FoodCache)  do

    local itemName = C_Item.GetItemNameByID(data.itemID)
    local itemIcon = C_Item.GetItemIconByID(data.itemID)

    ---
    local foodName = EasyReminders.AceGUI:Create("Label")
    foodName:SetText(itemName or L["Loading..."])
    foodName:SetFont(EasyReminders.Font, 12, "")
    foodName:SetWidth(230)
    foodName:SetImage(itemIcon)
    foodName:SetImageSize(16,16)
    scrollBox:AddChild(foodName)


    dataCache[data.itemID] = {data.buffID, itemName, itemIcon, nill, potionName, nill}
    if data.otherIds then
      for key, otherID in pairs(data.otherIds) do
        dataCache[otherID] = {data.buffID, itemName, C_Item.GetItemIconByID(otherID), nill, potionName, nill}
      end
    end

    local raid = EasyReminders.AceGUI:Create("CheckBox")
    raid:SetType("checkbox")
    raid:SetValue(false)
    raid:SetWidth(50)
    raid:SetValue((EasyReminders.charDB.food[data.itemID] and EasyReminders.charDB.food[data.itemID].raid) or false)
    scrollBox:AddChild(raid)
    raid:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.food[data.itemID] = EasyReminders.charDB.food[data.itemID] or {}
      EasyReminders.charDB.food[data.itemID].raid = value
      EasyReminders.FoodCheck:BuildTrackingList()
      EasyReminders.FoodCheck:CheckBuffs()
    end)

    local dungeon = EasyReminders.AceGUI:Create("CheckBox")
    dungeon:SetType("checkbox")
    dungeon:SetValue(false)
    dungeon:SetWidth(50)
    dungeon:SetValue((EasyReminders.charDB.food[data.itemID] and EasyReminders.charDB.food[data.itemID].dungeon) or false)
    dungeon:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.food[data.itemID] = EasyReminders.charDB.food[data.itemID] or {}
      EasyReminders.charDB.food[data.itemID].dungeon = value
      EasyReminders.FoodCheck:BuildTrackingList()
      EasyReminders.FoodCheck:CheckBuffs()
    end)
    scrollBox:AddChild(dungeon)

    local pvp = EasyReminders.AceGUI:Create("CheckBox")
    pvp:SetType("checkbox")
    pvp:SetValue(false)
    pvp:SetWidth(50)
    pvp:SetValue((EasyReminders.charDB.food[data.itemID] and EasyReminders.charDB.food[data.itemID].pvp) or false)
    pvp:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.food[data.itemID] = EasyReminders.charDB.food[data.itemID] or {}
      EasyReminders.charDB.food[data.itemID].pvp = value
      EasyReminders.FoodCheck:BuildTrackingList()
      EasyReminders.FoodCheck:CheckBuffs()
    end)
    scrollBox:AddChild(pvp)

    local delve = EasyReminders.AceGUI:Create("CheckBox")
    delve:SetType("checkbox")
    delve:SetValue(false)
    delve:SetWidth(50)
    delve:SetValue((EasyReminders.charDB.food[data.itemID] and EasyReminders.charDB.food[data.itemID].delve) or false)
    delve:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.food[data.itemID] = EasyReminders.charDB.food[data.itemID] or {}
      EasyReminders.charDB.food[data.itemID].delve = value
      EasyReminders.FoodCheck:BuildTrackingList()
      EasyReminders.FoodCheck:CheckBuffs()
    end)
    scrollBox:AddChild(delve)

    local outside = EasyReminders.AceGUI:Create("CheckBox")
    outside:SetType("checkbox")
    outside:SetValue(false)
    outside:SetWidth(50)
    outside:SetValue((EasyReminders.charDB.food[data.itemID] and EasyReminders.charDB.food[data.itemID].outside) or false)
    outside:SetCallback("OnValueChanged", function(_,_,value)
      EasyReminders.charDB.food[data.itemID] = EasyReminders.charDB.food[data.itemID] or {}
      EasyReminders.charDB.food[data.itemID].outside = value
      EasyReminders.FoodCheck:BuildTrackingList()
      EasyReminders.FoodCheck:CheckBuffs()
    end)
    scrollBox:AddChild(outside)

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

function WellFedTab:RefreshData()
  for itemID, data in pairs(dataCache) do
    local itemName = data[2] or C_Item.GetItemNameByID(itemID)
    local itemIcon = data[3] or C_Item.GetItemIconByID(itemID)
    local foodNameName = data[5]

    foodName:SetText(itemName or L["Loading..."])
    foodName:SetImage(itemIcon)

    buffName:SetText((spellInfo and spellInfo.name) or L["Loading..."])
    buffName:SetImage((spellInfo and spellInfo.iconID) or nil)

    dataCache[itemID] = {data[1], itemName, itemIcon, nil, foodName, nil}
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

  EasyReminders.FoodCheck:BuildTrackingList()
  EasyReminders.FoodCheck:CheckBuffs()
  WellFedTab:RebuildScrollBox()
 
end




