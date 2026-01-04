EasyReminders.BuffCheck = EasyReminders.BuffCheck or {}
local BuffCheck = EasyReminders.BuffCheck

local ConsumableCheck = EasyReminders.BuffCheck

local TrackingList = {}
local missingBuffs = {}

function BuffCheck:BuildTrackingList()

  TrackingList.outside = {}
  TrackingList.dungeon = {}
  TrackingList.raid = {}
  TrackingList.pvp = {}
  TrackingList.delve = {}

  for index, data in pairs(EasyReminders.BuffCache) do

    local spellIDs = {}
    if data.additionalBuffs then
      for k,v in pairs(data.additionalBuffs) do
        table.insert(spellIDs, v)
      end
    end
    table.insert(spellIDs, data.buffID)

    if EasyReminders.charDB.buff[data.buffID] then
      if EasyReminders.charDB.buff[data.buffID].outside then
          TrackingList.outside[data.buffID] = spellIDs
        end
        if EasyReminders.charDB.buff[data.buffID].dungeon then
          TrackingList.dungeon[data.buffID] = spellIDs
        end
        if EasyReminders.charDB.buff[data.buffID].raid then
          TrackingList.raid[data.buffID] = spellIDs
        end
        if EasyReminders.charDB.buff[data.buffID].pvp then
          TrackingList.pvp[data.buffID] = spellIDs
        end
        if EasyReminders.charDB.buff[data.buffID].delve then
          TrackingList.delve[data.buffID] = spellIDs
        end
    end
  end
end

function BuffCheck:CheckBuffs(missingBuffs)

  local trackingList = {}
   
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
  else
    trackingList = TrackingList.outside
  end

  if not _G.InCombatLockdown() and not C_ChallengeMode.IsChallengeModeActive() 
      and not C_PvP.IsMatchActive() and not (C_Secrets and C_Secrets.ShouldAurasBeSecret()) then
     local foundbuffs = {}

     _G.AuraUtil.ForEachAura("player", "HELPFUL", nil, function(_, _, _, _, _, _, _, _, _, spellID)
        if not (_G.issecretvalue and _G.issecretvalue(spellID)) then
            foundbuffs[spellID] = true 
       end
     end)
    for spellID, buffIDs in pairs(trackingList) do
      local expectedClass = EasyReminders.BuffCache[spellID].class
        if not expectedClass or expectedClass == class then
            for i, buffID in pairs(buffIDs) do
                if not foundbuffs[buffID] then
                    local spellInfo = C_Spell.GetSpellInfo(buffID)
                    missingBuffs[spellID] = spellInfo.iconID  -- we just want to show the parent Icon
                end
            end
        end
    end
  end
end
