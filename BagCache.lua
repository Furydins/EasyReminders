EasyReminders.BagCache = EasyReminders.BagCache or {}

local BagCache = EasyReminders.BagCache

local bagContentsCache = {}

function BagCache:RefreshBags()
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
                    bagContentsCache[itemID] = stackCount

                    if not EasyReminders.DataCache[itemId] or not EasyReminders.DataCache[itemId][2] then
                        local itemName = C_Item.GetItemNameByID(itemId)
                        local itemIcon = C_Item.GetItemIconByID(itemId)
                        local _,_,_,_,_,_,_,itemStackCount = C_Item.GetItemInfo(itemId)
                        EasyReminders.DataCache[itemId] = {itemId, itemName, itemIcon, itemStackCount}
                    end
                end
            end
        end
    end
end

function BagCache:GetBagCache()
  return bagContentsCache
end