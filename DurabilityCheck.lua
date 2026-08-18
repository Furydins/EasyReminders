EasyReminders.DurabilityCheck = EasyReminders.DurabilityCheck or {}

local DurabilityCheck = EasyReminders.DurabilityCheck

local missingBuffs = {}

--   dataCache[data.itemID] = {data.buffID, itemName, itemIcon, spellInfo, potionName, buffName, foodName}

function DurabilityCheck:CheckDurability(missingDurability)

  local foundDurability = {}
  local itemIconInfo = {}
   
  if not _G.InCombatLockdown() and not C_ChallengeMode.IsChallengeModeActive() 
      and not C_PvP.IsMatchActive() and not (C_Secrets and C_Secrets.ShouldAurasBeSecret()) then
    for index, data in pairs(EasyReminders.Data.GearSlots) do
        local current, maximum= _G.GetInventoryItemDurability(data.slotID)

        if current and maximum > 0 then
          missingDurability["repair"] = 136241
    end

  end
end
