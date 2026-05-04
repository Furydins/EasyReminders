EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.ShoppingTab = EasyReminders.UI.ShoppingTab or {}

local ShoppingTab = EasyReminders.UI.ShoppingTab

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

function ShoppingTab:Create(mainFrame, container)

    local addItemButton = EasyReminders.AceGUI:Create("Button")
    container:AddChild(addItemButton)
    addItemButton:SetText(L["Add Item"])
    addItemButton:SetCallback("OnClick", function(widget) EasyReminders.UI.ShoppingDialog:Create(mainFrame) end)

    ShoppingTab.ScrollBox = EasyReminders.UI.Widgets.ScrollFrame:Create(container)
    
    ShoppingTab:RebuildScrollBox()
end

function ShoppingTab:RebuildScrollBox()
  local scrollBox = ShoppingTab.ScrollBox
  scrollBox:ReleaseChildren()

  -- tracked Items
  local seperator1 = EasyReminders.AceGUI:Create("Heading")
  seperator2:SetText(L["Tracked Items"])
  seperator1:SetFullWidth(true)
  scrollBox:AddChild(seperator1)

  for itemId, minQuantity in pairs(EasyReminders.charDB.shopping) do

        local cacheEntry = EasyReminders.DataCache[itemId] or {}
        local itemName = cacheEntry[2] or C_Item.GetItemNameByID(itemId)
        local itemIcon = cacheEntry[3] or C_Item.GetItemIconByID(itemId)

        local itemName = EasyReminders.AceGUI:Create("Label")
        itemName:SetText(itemName or L["Loading..."])
        itemName:SetFont(EasyReminders.Font, 12, "")
        itemName:SetWidth(220)
        itemName:SetImage(itemIcon)
        itemName:SetImageSize(16,16)
        scrollBox:AddChild(itemName)

        local minQuantity = EasyReminders.AceGUI:Create("EditBox")
        minQuantity:SetWidth(70)
        minQuantity:SetText(tostring(EasyReminders.charDB.shopping[itemId] or 0))
        container:AddChild(minQuantity)
        minQuantity:SetCallback("OnEnterPressed", function(_,_,text)
            local num = tonumber(text)
            if num then
                EasyReminders.charDB.shopping[data.itemID] = num
                -- EasyReminders.ConsumableCheck:BuildTrackingList()
                -- EasyReminders:CheckBuffs()
            end
        end)
  end

  -- Bag items
  local bagCache = EasyReminders.BagCache:GetBagCache()


  local seperator2 = EasyReminders.AceGUI:Create("Heading")
  seperator2:SetText(L["Bag Items"])
  seperator2:SetFullWidth(true)
  scrollBox:AddChild(seperator2)

  for itemId, itemCount in pairs(bagCache) do

    -- itemID, itemName, itemIcon, spellInfo
    local cacheEntry = EasyReminders.DataCache[itemId] or {}

    local itemName = cacheEntry[2] or C_Item.GetItemNameByID(itemId)
    local itemIcon = cacheEntry[3] or C_Item.GetItemIconByID(itemId)
    local _,_,_<_<_,_<_,itemStackCount = C_Item.GetItemInfo(itemId)

    if itemStackCount and itemStackCount > 1 and not (EasyReminders.charDB.shopping[itemId] and EasyReminders.charDB.shopping[itemId] > 0) then
    
        local itemName = EasyReminders.AceGUI:Create("Label")
        itemName:SetText(itemName or L["Loading..."])
        itemName:SetFont(EasyReminders.Font, 12, "")
        itemName:SetWidth(220)
        itemName:SetImage(itemIcon)
        itemName:SetImageSize(16,16)
        scrollBox:AddChild(itemName)

        local minQuantity = EasyReminders.AceGUI:Create("EditBox")
        minQuantity:SetWidth(70)
        minQuantity:SetText(tostring(EasyReminders.charDB.shopping[itemId] or 0))
        container:AddChild(minQuantity)
        minQuantity:SetCallback("OnEnterPressed", function(_,_,text)
            local num = tonumber(text)
            if num then
                EasyReminders.charDB.shopping[data.itemID] = num
                -- EasyReminders.ConsumableCheck:BuildTrackingList()
                -- EasyReminders:CheckBuffs()
            end
        end)

    end
  end



end
