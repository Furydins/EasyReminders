EasyReminders.TrackingUtils = EasyReminders.TrackingUtils or {}

local TrackingUtils = EasyReminders.TrackingUtils

local function IsDungeonInCurrentSeason(targetMapID)
    C_MythicPlus.RequestMapInfo()
    local activeMaps = C_ChallengeMode.GetMapTable()
    for _, mapID in ipairs(activeMaps) do
        if mapID == targetMapID then
            return true
        end
    end
    return false
end

function TrackingUtils:IsDungeonInSeason()
  local _, instanceType, _, _, _, _, _, _, _, instanceMapID = _G.GetInstanceInfo()

  return instanceType == "party" and IsDungeonInCurrentSeason(instanceMapID)
  
end

function TrackingUtils:SelectTrackingList(outside, delve, dungeon, raid, pvp)
  
  local trackingList = nil
  local _, instanceType, difficultyID, _, _, _, _, _, _, _ = _G.GetInstanceInfo()
  local _, _, isHeroic, isChallengeMode, displayHeroic, displayMythic, _, isLFR, _, _ = _G.GetDifficultyInfo(difficultyID)

  if "raid" == instanceType then
    trackingList = outside
    if EasyReminders.globalDB.minimumRaidDifficulty == "LFR" then
      trackingList = raid
    elseif EasyReminders.globalDB.minimumRaidDifficulty == "NORMAL" and (not isLFR) then
      trackingList = raid
    elseif EasyReminders.globalDB.minimumRaidDifficulty == "HEROIC" and (displayHeroic or displayMythic) then
      trackingList = raid
    elseif EasyReminders.globalDB.minimumRaidDifficulty == "MYTHIC" and (displayMythic) then
      trackingList = raid
    end
    if C_Loot.IsLegacyLootModeEnabled() and EasyReminders.globalDB.ignoreLegacyRaids then
      trackingList = outside
    end
  elseif "party" == instanceType then
     trackingList = outside
    if EasyReminders.globalDB.minimumDungeonDifficulty == "NORMAL" then
      trackingList = dungeon
    elseif EasyReminders.globalDB.minimumDungeonDifficulty == "HEROIC" and (displayHeroic or displayMythic) then
      trackingList = dungeon
    elseif EasyReminders.globalDB.minimumDungeonDifficulty == "MYTHIC" and (displayMythic) then
      trackingList = dungeon
    end 
    if C_Loot.IsLegacyLootModeEnabled() and EasyReminders.globalDB.ignoreLegacyDungeons and (not displayMythic or not EasyReminders.TrackingUtils:IsDungeonInSeason()) then
      trackingList = outside
    end
  elseif "pvp" == instanceType then 
    trackingList = pvp
  elseif "scenario" == instanceType and difficultyID == 208 then
    trackingList = delve
  else
    trackingList = outside
  end
  return trackingList
end
