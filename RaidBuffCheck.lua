EasyReminders.RaidBuffCheck = EasyReminders.RaidBuffCheck or {}

local ConsumableCheck = EasyReminders.RaidBuffCheck

local TrackingList = {}
local missingBuffs = {}


function RaidBuffCheck:BuildTrackingList()

  TrackingList.personal = {}
  TrackingList.dungeon = {}
  TrackingList.raid = {}
  TrackingList.pvp = {}
  TrackingList.delve = {}

  for index, data in pairs(EasyReminders.Data:RaidBuffs) do

    local spellIDs = {}
    if data.additionalBuffs then
      for k,v in pairs(data.additionalBuffs) do
        table.insert(spellIDs, v)
      end
    end
    table.insert(spellIDs, data.buffID)

    if EasyReminders.charDB.raidBuff[data.buffID] then

        if EasyReminders.charDB.raidBuff[data.itemID].personal then
          TrackingList.personal[buffID] = spellIDs
        end
        if EasyReminders.charDB.raidBuff[data.itemID].raid then
          TrackingList.raid[buffID] = spellIDs
        end
        if EasyReminders.charDB.raidBuff[data.itemID].dungeon then
          TrackingList.dungeon[buffID] = spellIDs
        end
        if EasyReminders.charDB.raidBuff[data.itemID].pvp then
          TrackingList.pvp[buffID] = spellIDs
        end
        if EasyReminders.charDB.raidBuff[data.itemID].delve then
          TrackingList.delve[buffID] = spellIDs
        end
    end
  end
end

function RaidBuffCheck:CheckBuffs(missingBuffs)

   local trackingList = nil

   local _, class, _ = _G.UnitClass("player")
   inInstance, instanceType = _G.IsInInstance()

   if inInstance and "raid" == instanceType then
     trackingList = TrackingList.raid
   elseif inInstance and "party" == instanceType then 
     trackingList = TrackingList.dungeon
   elseif inInstance and "pvp" == instanceType then 
     trackingList = TrackingList.pvp
   elseif inInstance and "scenario" == instanceType  then
     trackingList = TrackingList.delve
   end
  -- check if we can scan auras

  if not _G.InCombatLockdown() and not C_ChallengeMode.IsChallengeModeActive() 
      and not C_PvP.IsMatchActive() and not C_Secrets.ShouldAurasBeSecret() then
     local foundbuffs = {}

     _G.AuraUtil.ForEachAura("player", "HELPFUL", nil, function(_, _, _, _, _, _, _, _, _, spellID)
        if not _G.issecretvalue(spellID) then
            foundbuffs[spellID] = true 
        end
     end)
    for spellID, buffIDs in pairs(TrackingList.personal) do
        local expectedClass = EasyReminders.Data:RaidBuffs[buffID].class
        if expectedClass == class then
            for i, buffID in pairs(buffIDs) do
                if foundbuffs[buffID] then
                     missingBuffs[spellID] = spellIDs  -- we just want to show the parent Icon
                end
            end
     
    end

     for spellID, buffIDs in pairs(trackingList) do
        -- Here goes the group check logic
    end
  end
end
