EasyReminders.ConsumableCheck = EasyReminders.ConsumableCheck or {}

local ConsumableCheck = EasyReminders.ConsumableCheck

local TrackingList = {}
local missingBuffs = {}

--   dataCache[data.itemID] = {data.buffID, itemName, itemIcon, spellInfo, potionName, buffName, foodName}

function ConsumableCheck:BuildTrackingList()

  TrackingList.outside = {}
  TrackingList.dungeon = {}
  TrackingList.raid = {}
  TrackingList.pvp = {}
  TrackingList.delve = {}

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
        if EasyReminders.charDB.potions[data.itemID].outside then
          TrackingList.outside[buffID] = { ["itemIDs"] = itemIDs, ["otherBuffs"] = data.otherBuffs }
        end
        if EasyReminders.charDB.potions[data.itemID].dungeon then
          TrackingList.dungeon[buffID] = { ["itemIDs"] = itemIDs, ["otherBuffs"] = data.otherBuffs }
        end
        if EasyReminders.charDB.potions[data.itemID].raid then
          TrackingList.raid[buffID] = { ["itemIDs"] = itemIDs, ["otherBuffs"] = data.otherBuffs }
        end
        if EasyReminders.charDB.potions[data.itemID].pvp then
          TrackingList.pvp[buffID] = { ["itemIDs"] = itemIDs, ["otherBuffs"] = data.otherBuffs }
        end
        if EasyReminders.charDB.potions[data.itemID].delve then
          TrackingList.delve[buffID] = { ["itemIDs"] = itemIDs, ["otherBuffs"] = data.otherBuffs }
        end
    end
  end
end

function ConsumableCheck:CheckBuffs(missingBuffs)


  local bagContentsCache = EasyReminders.BagCache:GetBagCache()
  local trackingList = nil

  local _, instanceType, difficultyID, _, _, _, _, _, _, _ = _G.GetInstanceInfo()
  local _, _, isHeroic, isChallengeMode, displayHeroic, displayMythic, _, isLFR, _, _ = _G.GetDifficultyInfo(difficultyID)

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
    if EasyReminders.globalDB.minimumDungeonDifficulty == "NORMAL" and (not isLFR) then
      trackingList = TrackingList.dungeon
    elseif EasyReminders.globalDB.minimumDungeonDifficulty == "HEROIC" and (displayHeroic or displayMythic) then
      trackingList = TrackingList.dungeon
    elseif EasyReminders.globalDB.minimumDungeonDifficulty == "MYTHIC" and (displayMythic) then
      trackingList = TrackingList.dungeon
    end 
    trackingList = TrackingList.dungeon
  elseif "pvp" == instanceType then 
    trackingList = TrackingList.pvp
  elseif "scenario" == instanceType and difficultyID == 208 then
    trackingList = TrackingList.delve
  else
    trackingList = TrackingList.outside
  end

  -- check if we can scan auras

  if trackingList and not _G.InCombatLockdown() and not C_ChallengeMode.IsChallengeModeActive() 
      and not C_PvP.IsMatchActive() and not (C_Secrets and C_Secrets.ShouldAurasBeSecret()) then
     local foundbuffs = {}

     _G.AuraUtil.ForEachAura("player", "HELPFUL", nil, function(_, _, _, _, _, _, _, _, _, spellID)
        if not (_G.issecretvalue and _G.issecretvalue(spellID)) then
            foundbuffs[spellID] = true 
        end
     end)
     for buffID, data in pairs(trackingList) do       
        if not foundbuffs[buffID] then
          for i, itemID in pairs(data.itemIDs) do
            if bagContentsCache[itemID] ~= nil then
              local filtered = false
              if data.otherBuffs then 
                for i, otherBuffID in pairs(data.otherBuffs) do
                  if foundbuffs[otherBuffID] then 
                    filtered = true
                    break
                  end
                end
              end
              if not filtered then
                local itemIcon 
                if not EasyReminders.DataCache[itemID] or not EasyReminders.DataCache[itemID][3] then
                  itemIcon = C_Item.GetItemIconByID(itemID)
                else
                  itemIcon = EasyReminders.DataCache[itemID][3]
                end
                missingBuffs[buffID] = itemIcon
                break
              end
            else
            end
          end
        end     
    end
  end
  EasyReminders.BagCache:RefreshBags()
end
