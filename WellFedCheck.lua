EasyReminders.WellFedCheck = EasyReminders.WellFedCheck or {}

local WellFedCheck = EasyReminders.WellFedCheck

local TrackingList = {}
local missingBuffs = {}

--   dataCache[data.itemID] = {data.buffID, itemName, itemIcon, spellInfo, potionName, buffName, foodName}

function WellFedCheck:BuildTrackingList()

  TrackingList.outside = {}
  TrackingList.dungeon = {}
  TrackingList.raid = {}
  TrackingList.pvp = {}
  TrackingList.delve = {}
  for index, data in pairs(EasyReminders.FoodCache) do



    local itemIDs = {}
    if data.otherIds then
      for k,v in pairs(data.otherIds) do
        table.insert(itemIDs, v, data.itemID)
      end
    end
    table.insert(itemIDs, data.itemID, data.itemID)

    for itemID, baseItemID in pairs(itemIDs) do

      if EasyReminders.charDB.food[baseItemID] then
          if EasyReminders.charDB.food[baseItemID].outside then
            TrackingList.outside[itemID] = itemID
          end
          if EasyReminders.charDB.food[baseItemID].dungeon then
            TrackingList.dungeon[itemID] = itemID
          end
          if EasyReminders.charDB.food[baseItemID].raid then
            TrackingList.raid[itemID] = itemID
          end
          if EasyReminders.charDB.food[baseItemID].pvp then
            TrackingList.pvp[itemID] = itemID
          end
          if EasyReminders.charDB.food[baseItemID].delve then
            TrackingList.delve[itemID] = itemID
          end
      end

    end
  end
  EasyReminders.BagCache:RefreshBags()
end

function WellFedCheck:CheckBuffs(missingBuffs)

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
      and not C_PvP.IsMatchActive() and not (C_Secrets and C_Secrets.ShouldAurasBeSecret()) then
     local foundbuffs = nil

     _G.AuraUtil.ForEachAura("player", "HELPFUL", nil, function(name, icon, _, _, _, _, _, _, _, spellID)
        if not (_G.issecretvalue and _G.issecretvalue(spellID)) then
            if EasyReminders.Data.FoodIcons[spellID] then
                foundbuffs = spellID
            end
        end
     end)

     if not foundbuffs then 
        for itemID, _ in pairs(trackingList) do
            if bagContentsCache[itemID] ~= nil then
                missingBuffs[itemID] = EasyReminders.DataCache[itemID][3]
                break
            end
        end
     end

  end
end

function WellFedCheck:PopulateData()
 for key, data in pairs(EasyReminders.FoodCache)  do

    local itemName = C_Item.GetItemNameByID(data.itemID)
    local itemIcon = C_Item.GetItemIconByID(data.itemID)

    EasyReminders:AddData(data.itemID, itemName, itemIcon, nil)
    if data.otherIds then
      for key, otherID in pairs(data.otherIds) do
        EasyReminders:AddData(otherID, itemName, C_Item.GetItemIconByID(otherID), spellInfo)
      end
    end

 end

end