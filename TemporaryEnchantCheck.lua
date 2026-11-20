EasyReminders.TemporaryEnchantCheck = EasyReminders.TemporaryEnchantCheck or {}

local TemporaryEnchantCheck = EasyReminders.TemporaryEnchantCheck

local missingBuffs = {}
local TrackingList = {}

--   dataCache[data.itemID] = {data.buffID, itemName, itemIcon, spellInfo, potionName, buffName, foodName}

local function contains(list, x)
  if not list then return false end
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
          TrackingList.outside[data.itemID] = { ["itemID"] = data.itemID, ["itemIDs"] = itemIDs, ["buffIDs"] = data.buffIDs, ["slotID"] = data.slotID }
        end
        if EasyReminders.charDB.gearConsumables[data.itemID].dungeon then
          TrackingList.dungeon[data.itemID] = { ["itemID"] = data.itemID, ["itemIDs"] = itemIDs, ["buffIDs"] = data.buffIDs, ["slotID"] = data.slotID } 
        end
        if EasyReminders.charDB.gearConsumables[data.itemID].raid then
          TrackingList.raid[data.itemID] = { ["itemID"] = data.itemID, ["itemIDs"] = itemIDs, ["buffIDs"] = data.buffIDs, ["slotID"] = data.slotID }
        end
        if EasyReminders.charDB.gearConsumables[data.itemID].pvp then
          TrackingList.pvp[data.itemID] = { ["itemID"] = data.itemID, ["itemIDs"] = itemIDs, ["buffIDs"] = data.buffIDs, ["slotID"] = data.slotID }
        end
        if EasyReminders.charDB.gearConsumables[data.itemID].delve then
          TrackingList.delve[data.itemID] = { ["itemID"] = data.itemID, ["itemIDs"] = itemIDs, ["buffIDs"] = data.buffIDs, ["slotID"] = data.slotID }
        end
    end
  end

  local _, class, _ = _G.UnitClass("player")
  for key, data in pairs(EasyReminders.Data.ClassEnchants)  do

    if data.class == class then
      local spellInfo = C_Spell.GetSpellInfo(data.buffID)
      
      for _, slotID in ipairs(data.slotIDs) do
        local keyName = slotID .. "-" .. data.buffID

        EasyReminders.charDB.gearImbues[keyName] = EasyReminders.charDB.gearImbues[keyName] or EasyReminders.charDB.gearImbues[data.buffID]
        -- TODO: Cleanup deprecated entries (Remove in 12.0.0)
        if EasyReminders.charDB.gearImbues[data.buffID] then
          EasyReminders.charDB.gearImbues[data.buffID] = nil
        end

        if EasyReminders.charDB.gearImbues[keyName] then
            if EasyReminders.charDB.gearImbues[keyName].outside then
              TrackingList.outside[keyName] = { ["buffID"] = data.buffID, ["otherIds"] = data.otherIds, ["spellID"] = data.spellID, ["slotID"] = slotID }
            end
            if EasyReminders.charDB.gearImbues[keyName].dungeon then
              TrackingList.dungeon[keyName] = { ["buffID"] = data.buffID, ["otherIds"] = data.otherIds, ["spellID"] = data.spellID, ["slotID"] = slotID } 
            end
            if EasyReminders.charDB.gearImbues[keyName].raid then
              TrackingList.raid[keyName] = { ["buffID"] = data.buffID, ["otherIds"] = data.otherIds, ["spellID"] = data.spellID, ["slotID"] = slotID }
            end
            if EasyReminders.charDB.gearImbues[keyName].pvp then
              TrackingList.pvp[keyName] = { ["buffID"] = data.buffID, ["otherIds"] = data.otherIds, ["spellID"] = data.spellID, ["slotID"] = slotID }
            end
            if EasyReminders.charDB.gearImbues[keyName].delve then
              TrackingList.delve[keyName] = { ["buffID"] = data.buffID, ["otherIds"] = data.otherIds, ["spellID"] = data.spellID, ["slotID"] = slotID }
            end
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

    for key, data in pairs(trackingList) do
      local itemID = data.itemID
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
                itemIcon = (EasyReminders.DataCache[itemID] and EasyReminders.DataCache[itemID][3]) or
                C_Item.GetItemIconByID(itemID)
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
           if data.slotID and data.slotID == 16 then          
                local enchantInfo = C_PaperDollInfo.GetTemporaryEnchantmentInfo(_G.INVSLOT_MAINHAND)
                if (not enchantInfo) or enchantInfo.remainingTimeMs <= (EasyReminders.charDB.gearMinTime * 60 * 1000) or not matchBuff(mainHandEnchantID, data.buffID, data.otherIds) then
                  missingEnchants[data.spellID] = spellIcon
                end
            elseif data.slotID and data.slotID == 17 then
                local enchantInfo = C_PaperDollInfo.GetTemporaryEnchantmentInfo(_G.INVSLOT_OFFHAND)
                if (not enchantInfo) or enchantInfo.remainingTimeMs <= (EasyReminders.charDB.gearMinTime * 60 * 1000) or not matchBuff(offHandEnchantID, data.buffID, data.otherIds) then
                    missingEnchants[data.spellID] = spellIcon      
                end
            end
      end
    end
  end
end
