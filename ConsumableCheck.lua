EasyReminders.ConsumableCheck = EasyReminders.ConsumableCheck or {}

local ConsumableCheck = EasyReminders.ConsumableCheck

local TrackingList = {}
local bagContentsCache = {}
local missingBuffs = {}

--   dataCache[data.itemID] = {data.buffID, itemName, itemIcon, spellInfo, potionName, buffName}

function ConsumableCheck:BuildTrackingList()

    TrackingList.outside = TrackingList.outside or {}
    TrackingList.dungeon = TrackingList.dungeon or {}
    TrackingList.raid = TrackingList.raid or {}

  for index, data in pairs(EasyReminders.Data.Consumables) do

    local itemIDs
    if data.otherIds then
      itemIDs = data.otherIds
      table.insert(itemIDs, data.itemID)
    else
      itemIDs = { data.itemID }
    end
    local buffID = data.buffID

    if EasyReminders.charDB.potions[data.itemID] then
        if EasyReminders.charDB.potions[data.itemID].outside then
          TrackingList.outside[buffID] = itemIDs
        else
            TrackingList.outside[buffID] = nil
        end
        if EasyReminders.charDB.potions[data.itemID].dungeon then
          TrackingList.dungeon[buffID] = itemIDs
        else
            TrackingList.dungeon[buffID] = nil
        end
        if EasyReminders.charDB.potions[data.itemID].raid then
          TrackingList.raid[buffID] = itemIDs
        else
            TrackingList.raid[buffID] = nil     
        end
    end
  end
end

function ConsumableCheck:CheckBuffs()

  EasyReminders.Print("Checking buffs...")
  local missingBuffs = {}
  local trackingList = nil

  inInstance, instanceType = _G.IsInInstance()

  if inInstance and instanceType == "raid" then
    trackingList = TrackingList.raid
  elseif inInstance and instanceType == "dungeon" then
    trackingList = TrackingList.dungeon
  elseif not inInstance then
    EasyReminders.Print("Checking buffs outside...")
    trackingList = TrackingList.outside
  else
    return
  end

  if trackingList then
     local foundbuffs = {}

     AuraUtil.ForEachAura("player", "HELPFUL", nil, function(_, _, _, _, _, _, _, _, _, spellID)
        if not issecretvalue(spellID) then
            EasyReminders.Print("Found buff: " .. spellID)
            foundbuffs[spellID] = true 
        end
     end)
     for buffID, itemIDs in pairs(trackingList) do
        EasyReminders.Print("Checking for buff ID: " .. buffID .. " " .. tostring(foundbuffs[buffID]))
        
        if not foundbuffs[buffID] then
          for i, itemID in pairs(itemIDs) do
            if bagContentsCache[itemID] then
                EasyReminders.Print("You have the consumable for buff ID: " .. buffID .. ".." .. itemID)
                missingBuffs[buffID] = itemID
                break
            else
                EasyReminders.Print("You are missing the consumable for buff ID: " .. buffID .. ".." .. itemID)
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