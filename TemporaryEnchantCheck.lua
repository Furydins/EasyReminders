EasyReminders.TemporaryEnchantCheck = EasyReminders.TemporaryEnchantCheck or {}

local TemporaryEnchantCheck = EasyReminders.TemporaryEnchantCheck

local missingBuffs = {}
local TrackingList = {}

--   dataCache[data.itemID] = {data.buffID, itemName, itemIcon, spellInfo, potionName, buffName, foodName}

local function hasEnchant(enchantID, buffIDs)
  for _, buffID in pairs(buffIDs) do
    if enchantID == buffID then
      return true
    end
  end
  return false
end

function TemporaryEnchantCheck:BuildTrackingList()

  TrackingList.outside = {}
  TrackingList.dungeon = {}
  TrackingList.raid = {}
  TrackingList.pvp = {}
  TrackingList.delve = {}

  for index, data in pairs(EasyReminders.GearConsumablesCache) do

    local itemIDs = {}
    if data.otherIds then
      for k,v in pairs(data.otherIds) do
        table.insert(itemIDs, v)
      end
    end
    table.insert(itemIDs, data.itemID)

    if EasyReminders.charDB.gearConsumables[data.itemID] then
        if EasyReminders.charDB.gearConsumables[data.itemID].outside then
          TrackingList.outside[data.itemID] = { ["itemIDs"] = itemIDs, ["buffIDs"] = data.buffIDs, ["slotID"] = data.slotID }
        end
        if EasyReminders.charDB.gearConsumables[data.itemID].dungeon then
          TrackingList.dungeon[data.itemID] = { ["itemIDs"] = itemIDs, ["buffIDs"] = data.buffIDs, ["slotID"] = data.slotID } 
        end
        if EasyReminders.charDB.gearConsumables[data.itemID].raid then
          TrackingList.raid[data.itemID] = { ["itemIDs"] = itemIDs, ["buffIDs"] = data.buffIDs, ["slotID"] = data.slotID }
        end
        if EasyReminders.charDB.gearConsumables[data.itemID].pvp then
          TrackingList.pvp[data.itemID] = { ["itemIDs"] = itemIDs, ["buffIDs"] = data.buffIDs, ["slotID"] = data.slotID }
        end
        if EasyReminders.charDB.gearConsumables[data.itemID].delve then
          TrackingList.delve[data.itemID] = { ["itemIDs"] = itemIDs, ["buffIDs"] = data.buffIDs, ["slotID"] = data.slotID }
        end
    end
  end
end

function TemporaryEnchantCheck:CheckEnchants(missingEnchants)

  local trackingList = nil
  local bagContentsCache = EasyReminders.BagCache:GetBagCache()
   
  if C_Loot.IsLegacyLootModeEnabled() and EasyReminders.globalDB.ignoreLegacyInstances then
    trackingList = TrackingList.outside
  elseif "raid" == instanceType then
    trackingList = TrackingList.outside
    if EasyReminders.globalDB.minimumRaidDifficulty == "LFR" then
      trackingList = TrackingList.raid
    elseif EasyReminders.globalDB.minimumRaidDifficulty == "NORMAL" and (not isLFR) then
      trackingList = TrackingList.raid
    elseif EasyReminders.globalDB.minimumRaidDifficulty == "HEROIC" and (displayHeroic or displayMythic) then
      trackingList = TrackingList.raid
    elseif EasyReminders.globalDB.minimumRaidDifficulty == "MYTHIC" and (displayMythic) then
      trackingList = TrackingList.raid
    end
  elseif "party" == instanceType then
     trackingList = TrackingList.outside
    if EasyReminders.globalDB.minimumDungeonDifficulty == "NORMAL" then
      trackingList = TrackingList.dungeon
    elseif EasyReminders.globalDB.minimumDungeonDifficulty == "HEROIC" and (displayHeroic or displayMythic) then
      trackingList = TrackingList.dungeon
    elseif EasyReminders.globalDB.minimumDungeonDifficulty == "MYTHIC" and (displayMythic) then
      trackingList = TrackingList.dungeon
    end 
  elseif "pvp" == instanceType then 
    trackingList = TrackingList.pvp
  elseif "scenario" == instanceType and difficultyID == 208 then
    trackingList = TrackingList.delve
  else
    trackingList = TrackingList.outside
  end

  hasMainHandEnchant, mainHandExpiration, _, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, _, offHandEnchantID, _, _, _, _ = _G.GetWeaponEnchantInfo()

    for itemID, data in pairs(trackingList) do
    
        local hasItem = false
        local baseItemID = nil
        for i, itemID in pairs(data.itemIDs) do
            if bagContentsCache[itemID] ~= nil then
                hasItem = true
                baseItemID = itemID
                break
            end
        end
        
        if hasItem then
            local itemIcon 
            if not EasyReminders.DataCache[baseItemID] or not EasyReminders.DataCache[baseItemID][3] then
                itemIcon = C_Item.GetItemIconByID(baseItemID)
            else
                itemIcon = EasyReminders.DataCache[itemID][3]
            end
            if data.slotID == 16 then
                if not hasMainHandEnchant or mainHandExpiration <= (EasyReminders.charDB.gearMinTime * 60 * 1000) or not hasEnchant(mainHandEnchantID, data.buffIDs) then
                    missingEnchants[itemID] = itemIcon
                end
            elseif data.slotID == 17 then
                if not hasOffHandEnchant or offHandExpiration <= (EasyReminders.charDB.gearMinTime * 60 * 1000) or not hasEnchant(offHandEnchantID, data.buffIDs) then
                    missingEnchants[itemID] = itemIcon      
                end
            end
        end
    end
end
