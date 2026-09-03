EasyReminders.BagCache = EasyReminders.BagCache or {}

local BagCache = EasyReminders.BagCache

local bagContentsCache = {}

function BagCache:RefreshBags(inventoryChange)
    bagContentsCache = {}
      -- Loop through player bags (0 is backpack, 1-4 are additional bags, 5 reagent bag)
    for bag = 0, 5 do
        -- Check if the bag exists/is accessible
        if C_Container.GetBagName(bag) then
            -- Loop through all slots in the current bag
            for slot = 1, C_Container.GetContainerNumSlots(bag) do
                -- Get the item link for the current slot
                local itemInfo = C_Container.GetContainerItemInfo(bag, slot)

                if itemInfo then
                    local itemID = itemInfo.itemID
                    local stackCount = itemInfo.stackCount or 0
                    -- 224464 = Demonic Healthstone - use charges instead of count 
                    if itemID == 224464  and stackCount > 0 then
                        stackCount = C_Item.GetItemCount(itemID, false, true) or stackCount
                    end
                    
                    bagContentsCache[itemID] = stackCount

                    if inventoryChange and EasyReminders.charDB.shopping[itemID] and EasyReminders.charDB.shopping[itemID] > 0 then
                        EasyReminders.charDB.currentInventory[itemID] = stackCount
                    end

                    if not EasyReminders.DataCache[itemID] or not EasyReminders.DataCache[itemID][2] then
                        local itemName = C_Item.GetItemNameByID(itemID)
                        local itemIcon = C_Item.GetItemIconByID(itemID)
                        local _,_,_,_,_,_,_,itemStackCount = C_Item.GetItemInfo(itemID)
                        EasyReminders.DataCache[itemID] = {itemID, itemName, itemIcon, nil, itemStackCount}
                    end
                end
            end
        end
    end
end

function BagCache:GetBagCache()
  return bagContentsCache
end