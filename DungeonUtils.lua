EasyReminders.DungeonUtils = EasyReminders.DungeonUtils or {}

local DungeonUtils = EasyReminders.DungeonUtils

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

function DungeonUtils:IsDungeonInSeason()
  local _, instanceType, _, _, _, _, _, _, _, instanceMapID = _G.GetInstanceInfo()

  return instanceType == "party" and IsDungeonInCurrentSeason(instanceMapID)
  
end
