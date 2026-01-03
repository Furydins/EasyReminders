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

    local itemID = data.itemID

    if EasyReminders.charDB.food[itemID] then
        if EasyReminders.charDB.food[itemID].outside then
          TrackingList.outside[itemID] = itemID
        end
        if EasyReminders.charDB.food[itemID].dungeon then
          TrackingList.dungeon[itemID] = itemID
        end
        if EasyReminders.charDB.food[itemID].raid then
          TrackingList.raid[itemID] = itemID
        end
        if EasyReminders.charDB.food[itemID].pvp then
          TrackingList.pvp[itemID] = itemID
        end
        if EasyReminders.charDB.food[itemID].delve then
          TrackingList.delve[itemID] = itemID
        end
    end
  end
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
      and not C_PvP.IsMatchActive() and not C_Secrets.ShouldAurasBeSecret() then
     local foundbuffs = nil

     _G.AuraUtil.ForEachAura("player", "HELPFUL", nil, function(name, icon, _, _, _, _, _, _, _, spellID)
        if not _G.issecretvalue(spellID) then
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
 end

end