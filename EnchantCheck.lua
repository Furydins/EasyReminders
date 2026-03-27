EasyReminders.EnchantCheck = EasyReminders.EnchantCheck or {}

local EnchantCheck = EasyReminders.EnchantCheck

local missingBuffs = {}

--   dataCache[data.itemID] = {data.buffID, itemName, itemIcon, spellInfo, potionName, buffName, foodName}

function EnchantCheck:CheckEnchants(missingEnchants)

  local foundEnchants = {}
  local itemIconInfo = {}
   
  local _, class, _ = _G.UnitClass("player")


  if not _G.InCombatLockdown() and not C_ChallengeMode.IsChallengeModeActive() 
      and not C_PvP.IsMatchActive() and not (C_Secrets and C_Secrets.ShouldAurasBeSecret()) then
    for index, data in pairs(EasyReminders.Data.GearSlots) do
        local itemLink = GetInventoryItemLink("player", data.slotID)
        --EasyReminders:Print("Checking slot", data.slotName, "for enchants. Item link:", itemLink)
        if itemLink then
          local itemLinkData = EasyReminders.ItemLinkParser:ParseItemLink(itemLink, data.slotID == 5)
          if data.slotID == 5 then
            EasyReminders:Print("Parsed item link data:", unpack(itemLinkData), itemLinkData.enchantID and "has enchants" or "no enchants")
            for k, v in pairs(itemLinkData) do
              EasyReminders:Print("Key:", k, "Value:", v)
            end
          end
          itemIconInfo[data.slotID] = C_Item.GetItemIconByID(itemLinkData.itemID)
          if itemLinkData.enchantID then
            foundEnchants[data.slotID] = true
          end
        end
    end

    for index, data in pairs(EasyReminders.Data.GearSlots) do
      if data.enchantable and EasyReminders.charDB.gear[data.slotID] and EasyReminders.charDB.gear[data.slotID].enchant and not foundEnchants[data.slotID] then
        local _, slotTexture, _ = GetInventorySlotInfo(data.slotNameID)
        local itemTexture = itemIconInfo[data.slotID]
        missingEnchants[data.slotName] = itemTexture or slotTexture
      end
    end
  end
end
