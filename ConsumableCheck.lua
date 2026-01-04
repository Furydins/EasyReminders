EasyReminders.ConsumableCheck = EasyReminders.ConsumableCheck or {}

local ConsumableCheck = EasyReminders.ConsumableCheck

local TrackingList = {}
local missingBuffs = {}

--   dataCache[data.itemID] = {data.buffID, itemName, itemIcon, spellInfo, potionName, buffName, foodName}

function ConsumableCheck:BuildTrackingList()

  EasyReminders:RefreshData()

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

  inInstance, instanceType = _G.IsInInstance()

  if inInstance and "raid" == instanceType then
    trackingList = TrackingList.raid
  elseif inInstance and "party" == instanceType then 
    trackingList = TrackingList.dungeon
  elseif inInstance and "pvp" == instanceType then 
    trackingList = TrackingList.pvp
  elseif inInstance and "scenario" == instanceType  then
    trackingList = TrackingList.delve
  else
    trackingList = TrackingList.outside
  end

  -- check if we can scan auras

  if trackingList and not _G.InCombatLockdown() and not C_ChallengeMode.IsChallengeModeActive() 
      and not C_PvP.IsMatchActive() and (C_Secrets and (not C_Secrets.ShouldAurasBeSecret())) then
     local foundbuffs = {}

     _G.AuraUtil.ForEachAura("player", "HELPFUL", nil, function(_, _, _, _, _, _, _, _, _, spellID)
        if not _G.issecretvalue(spellID) then
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

                missingBuffs[buffID] = EasyReminders.DataCache[itemID][3]
                break
              end
            else
            end
          end
        end     
    end
  end
end


function ConsumableCheck:PopulateData()
 for key, data in pairs(EasyReminders.ConsumableCache)  do

    local itemName = C_Item.GetItemNameByID(data.itemID)
    local itemIcon = C_Item.GetItemIconByID(data.itemID)
    local spellInfo = C_Spell.GetSpellInfo(data.buffID)

    EasyReminders:AddData(data.itemID, itemName, itemIcon, spellInfo)
    if data.otherIds then
      for key, otherID in pairs(data.otherIds) do
        EasyReminders:AddData(otherID, itemName, C_Item.GetItemIconByID(otherID), spellInfo)
      end
    end

  end
end