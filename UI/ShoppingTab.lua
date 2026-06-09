EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.ShoppingTab = EasyReminders.UI.ShoppingTab or {}

EasyReminders.Shopping = EasyReminders.Shopping or {}
EasyReminders.Shopping.Notifications = EasyReminders.Shopping.otifications or {}

local ShoppingTab = EasyReminders.UI.ShoppingTab

EasyReminders.Data.Shopping = EasyReminders.Data.Shopping or {}
EasyReminders.Data.Shopping.LOGIN = "LOGIN"
EasyReminders.Data.Shopping.INSTANCE_EXIT = "INSTANCE_EXIT" 
EasyReminders.Data.Shopping.ON_USE = "ON_USE"

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

local function addEntry(itemId, itemName, itemIcon, scrollBox)
    local itemNameLabel = EasyReminders.AceGUI:Create("Label")
    itemNameLabel:SetText(itemName or L["Loading..."])
    itemNameLabel:SetFont(EasyReminders.Font, 12, "")
    itemNameLabel:SetWidth(420)
    itemNameLabel:SetImage(itemIcon)
    itemNameLabel:SetImageSize(16,16)
    scrollBox:AddChild(itemNameLabel)

    local minQuantity = EasyReminders.AceGUI:Create("EditBox")
    minQuantity:SetWidth(70)
    minQuantity:SetText(tostring(EasyReminders.charDB.shopping[itemId] or 0))
    scrollBox:AddChild(minQuantity)
    minQuantity:SetCallback("OnEnterPressed", function(_,_,text)
        local num = tonumber(text)
        if num then
            if num > 0 then
                EasyReminders.charDB.shopping[itemId] = num
            elseif num and num == 0 then
                    EasyReminders.charDB.shopping[itemId] = nil
            end
        end
    end)

end

function ShoppingTab:Create(mainFrame, container)

    EasyReminders.Shopping.Notifcations = {["LOGIN"] = EasyReminders.charDB.shoppingNotifications.LOGIN,
                ["INSTANCE_EXIT"] = EasyReminders.charDB.shoppingNotifications.INSTANCE_EXIT,  
                ["ON_USE"] = EasyReminders.charDB.shoppingNotifications.ON_USE,}

    local notificationText = EasyReminders.AceGUI:Create("Label")
    notificationText:SetText(L["Notifications:"])
    notificationText:SetWidth(80)
    container:AddChild(notificationText)

    local notificationDropdown = EasyReminders.AceGUI:Create("Dropdown")
    notificationDropdown:SetWidth(150)
    notificationDropdown:SetList({
        [EasyReminders.Data.Shopping.LOGIN] = L["On Login"],
        [EasyReminders.Data.Shopping.INSTANCE_EXIT] = L["On Instance Exit"],
        [EasyReminders.Data.Shopping.ON_USE] = L["On Item Use"],

    })
    notificationDropdown:SetMultiselect(true)
    notificationDropdown:SetItemValue(EasyReminders.Data.Shopping.LOGIN, EasyReminders.Shopping.Notifcations.LOGIN)
    notificationDropdown:SetItemValue(EasyReminders.Data.Shopping.INSTANCE_EXIT, EasyReminders.Shopping.Notifcations.INSTANCE_EXIT)
    notificationDropdown:SetItemValue(EasyReminders.Data.Shopping.ON_USE,EasyReminders.Shopping.Notifcations.ON_USE)
    container:AddChild(notificationDropdown)

    notificationDropdown:SetCallback("OnValueChanged", function(_,_,key, checked)
        EasyReminders.Shopping.Notifcations[key] = checked   
        EasyReminders.charDB.shoppingNotifications[key] = checked
    end)
    
    ShoppingTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)

    ShoppingTab:RebuildScrollBox()
end

function ShoppingTab:RebuildScrollBox()
  EasyReminders.BagCache:RefreshBags()
  local scrollBox = ShoppingTab.ScrollBox
  scrollBox:ReleaseChildren()

  local trackedEntries = {}
  for itemId, minQuantity in pairs(EasyReminders.charDB.shopping) do
    if minQuantity and minQuantity > 0 then
      local cacheEntry = EasyReminders.DataCache[itemId] or {}
      local itemName = cacheEntry[2] or C_Item.GetItemNameByID(itemId)
      local itemIcon = cacheEntry[3] or C_Item.GetItemIconByID(itemId)
      table.insert(trackedEntries, {itemId = itemId, itemName = itemName, itemIcon = itemIcon})
    end
  end

  table.sort(trackedEntries, function(a, b)
    local nameA = a.itemName or ""
    local nameB = b.itemName or ""
    if nameA ~= nameB then
      return nameA < nameB
    end
    return a.itemId < b.itemId
  end)

  -- tracked Items
  local seperator1 = EasyReminders.AceGUI:Create("Heading")
  seperator1:SetText(L["Tracked Items"])
  seperator1:SetFullWidth(true)
  scrollBox:AddChild(seperator1)

  for _, entry in ipairs(trackedEntries) do
    addEntry(entry.itemId, entry.itemName, entry.itemIcon, scrollBox)
  end

  -- Bag items
  local bagEntries = {}
  local bagCache = EasyReminders.BagCache:GetBagCache()
  for itemId, itemCount in pairs(bagCache) do
    local cacheEntry = EasyReminders.DataCache[itemId] or {}
    local itemName = cacheEntry[2] or C_Item.GetItemNameByID(itemId)
    local itemIcon = cacheEntry[3] or C_Item.GetItemIconByID(itemId)
    local itemStackCount = cacheEntry[5]
    if not itemStackCount then
      _,_,_,_,_,_,_,itemStackCount = C_Item.GetItemInfo(itemId)
    end
    -- 224464 = Demonic Healthstone
    if (((itemId and itemId == 224464) or (itemStackCount and itemStackCount > 1)) and not (EasyReminders.charDB.shopping[itemId] and EasyReminders.charDB.shopping[itemId] > 0)) then
      table.insert(bagEntries, {itemId = itemId, itemName = itemName, itemIcon = itemIcon})
    end
  end

  table.sort(bagEntries, function(a, b)
    local nameA = a.itemName or ""
    local nameB = b.itemName or ""
    if nameA ~= nameB then
      return nameA < nameB
    end
    return a.itemId < b.itemId
  end)

  local seperator2 = EasyReminders.AceGUI:Create("Heading")
  seperator2:SetText(L["Bag Items"])
  seperator2:SetFullWidth(true)
  scrollBox:AddChild(seperator2)

  for _, entry in ipairs(bagEntries) do
    addEntry(entry.itemId, entry.itemName, entry.itemIcon, scrollBox)
  end
end
