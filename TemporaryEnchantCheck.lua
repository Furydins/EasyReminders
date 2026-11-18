EasyReminders.TemporaryEnchantCheck = EasyReminders.TemporaryEnchantCheck or {}

local TemporaryEnchantCheck = EasyReminders.TemporaryEnchantCheck

local missingBuffs = {}
local TrackingList = {}

--   dataCache[data.itemID] = {data.buffID, itemName, itemIcon, spellInfo, potionName, buffName, foodName}

local function contains(list, x)
	for _, v in ipairs(list) do
		if v == x then return true end
	end
	return false
end

local function matchBuff(buffToMatch, buffId, buffIds)
  if buffToMatch == buffId then
    return true
  end
  return contains(buffIds, buffToMatch)
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

  local _, class, _ = _G.UnitClass("player")
  for key, data in pairs(EasyReminders.Data.ClassEnchants)  do

    if data.class == class then
      local spellInfo = C_Spell.GetSpellInfo(data.buffID)
    

     if EasyReminders.charDB.gearImbues[data.buffID] then
        if EasyReminders.charDB.gearImbues[data.buffID].outside then
          TrackingList.outside[data.buffID] = { ["buffID"] = data.buffID, ["spellID"] = data.spellID, ["slotID"] = data.slotID, ["slotIds"] = data.slotIDs }
        end
        if EasyReminders.charDB.gearImbues[data.buffID].dungeon then
          TrackingList.dungeon[data.buffID] = { ["buffID"] = data.buffID, ["spellID"] = data.spellID, ["slotID"] = data.slotID, ["slotIds"] = data.slotIDs } 
        end
        if EasyReminders.charDB.gearImbues[data.buffID].raid then
          TrackingList.raid[data.buffID] = { ["buffID"] = data.buffID, ["spellID"] = data.spellID, ["slotID"] = data.slotID, ["slotIds"] = data.slotIDs }
        end
        if EasyReminders.charDB.gearImbues[data.buffID].pvp then
          TrackingList.pvp[data.buffID] = { ["buffID"] = data.buffID, ["spellID"] = data.spellID, ["slotID"] = data.slotID, ["slotIds"] = data.slotIDs }
        end
        if EasyReminders.charDB.gearImbues[data.buffID].delve then
          TrackingList.delve[data.buffID] = { ["buffID"] = data.buffID, ["spellID"] = data.spellID, ["slotID"] = data.slotID, ["slotIds"] = data.slotIDs }
        end
      end
    end
  end
end

function TemporaryEnchantCheck:CheckEnchants(missingEnchants)

  local trackingList = nil
  local bagContentsCache = EasyReminders.BagCache:GetBagCache()

  local trackingList = EasyReminders.TrackingUtils:SelectTrackingList(TrackingList.outside, TrackingList.delve, TrackingList.dungeon, TrackingList.raid, TrackingList.pvp)


  if trackingList and not _G.InCombatLockdown() and not C_ChallengeMode.IsChallengeModeActive() 
      and not C_PvP.IsMatchActive() and not (C_Secrets and C_Secrets.ShouldAurasBeSecret()) then

     hasMainHandEnchant, mainHandExpiration, _, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, _, offHandEnchantID, _, _, _, _ = _G.GetWeaponEnchantInfo()

    for itemID, data in pairs(trackingList) do
   
      if data.itemIDs then
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
                local enchantInfo = C_PaperDollInfo.GetTemporaryEnchantmentInfo(_G.INVSLOT_MAINHAND)
                if (not enchantInfo) or enchantInfo.remainingTimeMs <= (EasyReminders.charDB.gearMinTime * 60 * 1000) or not contains(data.buffIDs, mainHandEnchantID) then
                    missingEnchants[itemID] = itemIcon
                end
            elseif data.slotID == 17 then
                local enchantInfo = C_PaperDollInfo.GetTemporaryEnchantmentInfo(_G.INVSLOT_OFFHAND)
                if (not enchantInfo) or enchantInfo.remainingTimeMs <= (EasyReminders.charDB.gearMinTime * 60 * 1000) or not contains(data.buffIDs, offHandEnchantID) then
                    missingEnchants[itemID] = itemIcon      
                end
            end
        end
      else
          local spellInfo = C_Spell.GetSpellInfo(data.spellID)
          local spellIcon = spellInfo and spellInfo.iconID or nil
           if (data.slotID and data.slotID == 16) or (data.slotIds and contains(data.slotIds, 16)) then          
                local enchantInfo = C_PaperDollInfo.GetTemporaryEnchantmentInfo(_G.INVSLOT_MAINHAND)
                if (not enchantInfo) or enchantInfo.remainingTimeMs <= (EasyReminders.charDB.gearMinTime * 60 * 1000) or not matchBuff(mainHandEnchantID, data.buffID, data.otherIds) then
                  missingEnchants[data.spellID] = spellIcon
                end
            elseif (data.slotID and data.slotID == 17) or (data.slotIds and contains(data.slotIds, 17)) then
                local enchantInfo = C_PaperDollInfo.GetTemporaryEnchantmentInfo(_G.INVSLOT_OFFHAND)
                if (not enchantInfo) or enchantInfo.remainingTimeMs <= (EasyReminders.charDB.gearMinTime * 60 * 1000) or not matchBuff(offHandEnchantID, data.buffID, data.otherIds) then
                    missingEnchants[data.spellID] = spellIcon      
                end
            end
      end
    end
  end
end
