EasyReminders.ConsumableCheck = EasyReminders.ConsumableCheck or {}

local ConsumableCheck = EasyReminders.ConsumableCheck

local TrackingList = {}
local bagContentsCache = {}
local missingBuffs = {}

--   dataCache[data.itemID] = {data.buffID, itemName, itemIcon, spellInfo, potionName, buffName}

function ConsumableCheck:BuildTrackingList()

  TrackingList.outside = {}
  TrackingList.dungeon = {}
  TrackingList.raid = {}

  for index, data in pairs(EasyReminders.ConsumableCache) do

    local itemIDs = {}
    if data.otherIds then
      for k,v in pairs(data.otherIds) do
        table.insert(itemIDs, v)
      end
    end
    table.insert(itemIDs, data.itemID)
    local buffID = data.buffID

    if EasyReminders.charDB.potions[data.itemID] then
        EasyReminders:Print("Adding Tracker for" .. data.itemID)
        if EasyReminders.charDB.potions[data.itemID].outside then
          EasyReminders:Print("Adding Outdoor Tracker for" .. buffID)
          TrackingList.outside[buffID] = itemIDs
        end
        if EasyReminders.charDB.potions[data.itemID].dungeon then
          TrackingList.dungeon[buffID] = itemIDs
        end
        if EasyReminders.charDB.potions[data.itemID].raid then
          TrackingList.raid[buffID] = itemIDs
        end
    end
  end
end

function ConsumableCheck:CheckBuffs()

  local missingBuffs = {}
  local trackingList = nil

  inInstance, instanceType = _G.IsInInstance()

  if inInstance and instanceType == "raid" then
    trackingList = TrackingList.raid
  elseif inInstance and instanceType == "dungeon" then
    trackingList = TrackingList.dungeon
  elseif not inInstance then
    trackingList = TrackingList.outside
  else
    return
  end

  if trackingList then
     local foundbuffs = {}

     AuraUtil.ForEachAura("player", "HELPFUL", nil, function(_, _, _, _, _, _, _, _, _, spellID)
        if not issecretvalue(spellID) then
            foundbuffs[spellID] = true 
        end
     end)
     for buffID, itemIDs in pairs(trackingList) do
        EasyReminders:Print("Tracking...", buffID, itemIDs)
        
        if not foundbuffs[buffID] then
          for i, itemID in pairs(itemIDs) do
            if bagContentsCache[itemID] ~= nil then
                missingBuffs[buffID] = itemID
                break
            else
            end
          end
        end     
    end
  end
  EasyReminders.UI.NotificationWindow:UpdateNotifications(missingBuffs)
end

function ConsumableCheck:GetBagItems()
    EasyReminders.Print("Getting bag items...")
    bagContentsCache = {}
      -- Loop through player bags (0 is backpack, 1-4 are additional bags, 5 reagent bag)
    for bag = 0, 5 do
        -- Check if the bag exists/is accessible
        if C_Container.GetBagName(bag) then
            EasyReminders.Print("Checking bag: " .. C_Container.GetBagName(bag))
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

function ConsumableCheck:GetBagCache()
  return bagContentsCache
end