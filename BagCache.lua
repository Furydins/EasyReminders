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
                local itemID = C_Container.GetContainerItemID(bag, slot)
                if itemID then
                    bagContentsCache[itemID] = true
                end
            end
        end
    end
end

function BagCache:GetBagCache()
  return bagContentsCache
end