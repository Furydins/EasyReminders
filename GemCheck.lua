EasyReminders.GemCheck = EasyReminders.GemCheck or {}

local GemCheck = EasyReminders.GemCheck

--   dataCache[data.itemID] = {data.buffID, itemName, itemIcon, spellInfo, potionName, buffName, foodName}

function GemCheck:CheckGems(missingGems)

  local foundGems = {}
  local itemIconInfo = {}
   
  local _, class, _ = _G.UnitClass("player")


  if not _G.InCombatLockdown() and not C_ChallengeMode.IsChallengeModeActive() 
      and not C_PvP.IsMatchActive() and not (C_Secrets and C_Secrets.ShouldAurasBeSecret()) then
    for index, data in pairs(EasyReminders.Data.GearSlots) do
        local itemLink = GetInventoryItemLink("player", data.slotID)
        if itemLink then
          local itemLinkData = EasyReminders.ItemLinkParser:ParseItemLink(itemLink)
          itemIconInfo[data.slotID] = C_Item.GetItemIconByID(itemLinkData.itemID)
          if itemLinkData.gems and itemLinkData.gems[1] then
            foundGems[data.slotID] = true
          end
        end
    end

    for index, data in pairs(EasyReminders.Data.GearSlots) do
      if data.gemable and EasyReminders.charDB.gear[data.slotID] and EasyReminders.charDB.gear[data.slotID].gem and not foundGems[data.slotID] then
        local _, slotTexture, _ = GetInventorySlotInfo(data.slotNameID)
        local itemTexture = itemIconInfo[data.slotID]
        missingGems[data.slotName] = itemTexture or slotTexture
      end
    end
  end
end
