EasyReminders = _G.LibStub("AceAddon-3.0"):NewAddon("EasyReminders", "AceConsole-3.0")

EasyReminders.AceGUI = _G.LibStub("AceGUI-3.0")
EasyReminders.AceConfig = _G.LibStub("AceConfig-3.0")
EasyReminders.AceConfigDialog = _G.LibStub("AceConfigDialog-3.0")


L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

EasyReminders.MainWindow = nil
EasyReminders.Font = "Fonts\\FRIZQT__.TTF"

EasyReminders.NotificationWindow = nil

EasyReminders.DataCache = {}
EasyReminders.ConsumableCache = {}
EasyReminders.FoodCache = {}
EasyReminders.BuffCache = {}
EasyReminders.GearConsumablesCache = {}

local HolidayFrame = nil
local ShoppingFrame = nil

local inInstance, instanceType

local loadFrame

function EasyReminders:OnInitialize()

     -- Initialise Database
    EasyReminders.globalDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersDB").global
    EasyReminders.charDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersCharDB").char

    EasyReminders.charDB.potions = EasyReminders.charDB.potions or {}
    EasyReminders.charDB.food = EasyReminders.charDB.food or {}
    EasyReminders.charDB.buff = EasyReminders.charDB.buff or {}
    EasyReminders.charDB.holiday = EasyReminders.charDB.holiday or {}
    EasyReminders.charDB.group = EasyReminders.charDB.group or {}
     EasyReminders.charDB.groupShown = EasyReminders.charDB.groupShown or {}
    EasyReminders.charDB.gear = EasyReminders.charDB.gear or {}
    EasyReminders.charDB.gearConsumables = EasyReminders.charDB.gearConsumables or {}
    EasyReminders.charDB.gearImbues = EasyReminders.charDB.gearImbues or {}
    EasyReminders.charDB.shopping = EasyReminders.charDB.shopping or {}
    EasyReminders.charDB.currentInventory = EasyReminders.charDB.currentInventory or {}
    EasyReminders.charDB.potionsMinTime = EasyReminders.charDB.potionsMinTime or 0
    EasyReminders.charDB.foodMinTime = EasyReminders.charDB.foodMinTime or 0
    EasyReminders.charDB.buffMinTime = EasyReminders.charDB.buffMinTime or 0
    EasyReminders.charDB.gearMinTime = EasyReminders.charDB.gearMinTime or 0
    EasyReminders.charDB.minDurability = EasyReminders.charDB.minDurability or 0

    EasyReminders.charDB.filterConsumables = EasyReminders.charDB.filterConsumables or {["MIDNIGHT"] = true, ["TWW"] = false, ["CUSTOM"] = true, ["OTHER"] = true}
    EasyReminders.charDB.filterFood = EasyReminders.charDB.filterFood or {["MIDNIGHT"] = true, ["TWW"] = false, ["CUSTOM"] = true, ["OTHER"] = true}
    EasyReminders.charDB.filterGear = EasyReminders.charDB.filterFood or {["MIDNIGHT"] = true, ["TWW"] = false, ["CUSTOM"] = true, ["OTHER"] = true}
    EasyReminders.charDB.filterHolidays = EasyReminders.charDB.filterHolidays or {["MAJOR"] = true, ["MICRO"] = true, ["BRAWL"] = true, ["TIMEWALKING"] = true, ["SKYRIDING"] = true, ["OTHER"] = true}
    EasyReminders.charDB.shoppingNotifications = EasyReminders.charDB.shoppingNotifications or {["LOGIN"] = false, ["INSTANCE_EXIT"] = false, ["ON_USE"] = true, ["NEAR_AH"] = false}

    if EasyReminders.globalDB.enabled == nil then
        EasyReminders.globalDB.enable = true
    end
    EasyReminders.globalDB.customConsumables = EasyReminders.globalDB.customConsumables or {}
    EasyReminders.globalDB.customFood = EasyReminders.globalDB.customFood or {}
    EasyReminders.globalDB.customBuffs = EasyReminders.globalDB.customBuffs or {}
    EasyReminders.globalDB.customGearConsumables = EasyReminders.globalDB.customGearConsumables or {}
    EasyReminders.globalDB.orientation = EasyReminders.globalDB.orientation or "VERTICAL"
    if EasyReminders.globalDB.ignoreLegacyDungeons == nil then
        if EasyReminders.globalDB.ignoreLegacyInstances ~= nil then
            EasyReminders.globalDB.ignoreLegacyDungeons = EasyReminders.globalDB.ignoreLegacyInstances
        else
            EasyReminders.globalDB.ignoreLegacyDungeons = false 
        end
    end
    if EasyReminders.globalDB.ignoreLegacyRaids == nil then
        if EasyReminders.globalDB.ignoreLegacyInstances ~= nil then
            EasyReminders.globalDB.ignoreLegacyRaids = EasyReminders.globalDB.ignoreLegacyInstances
        else
            EasyReminders.globalDB.ignoreLegacyRaids = false
        end
    end
     if EasyReminders.globalDB.minimumDungeonDifficulty == nil then
        EasyReminders.globalDB.minimumDungeonDifficulty = "NORMAL"
    end
    if EasyReminders.globalDB.minimumRaidDifficulty == nil then
        EasyReminders.globalDB.minimumRaidDifficulty = "LFR"
    end
    
    EasyReminders:RegisterChatCommand("er", "OpenGUI")
    EasyReminders:RegisterChatCommand("easyreminders", "OpenGUI")

    EasyReminders.ConsumableCache = EasyReminders:ConcatenateTables(EasyReminders.Data.Consumables, EasyReminders.globalDB.customConsumables)
    EasyReminders.FoodCache = EasyReminders:ConcatenateTables(EasyReminders.Data.Food, EasyReminders.globalDB.customFood)
    EasyReminders.BuffCache = EasyReminders:ConcatenateTables(EasyReminders.Data.Buffs, EasyReminders.globalDB.customBuffs)
    EasyReminders.GearConsumablesCache = EasyReminders:ConcatenateTables(EasyReminders.Data.GearConsumables, EasyReminders.globalDB.customGearConsumables)
    
    EasyReminders:RegisterEvents()

    loadFrame = _G.CreateFrame("Frame")
    loadFrame:SetScript("onEvent", function(frame, event, itemID, success)
        EasyReminders:RefreshItem(itemID, success)
    end)
    loadFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")

    -- Prime Cache
   
    for i, data in pairs(EasyReminders.ConsumableCache) do
        local itemID = data.itemID
        local itemName = C_Item.GetItemNameByID(itemID)
        local itemIcon = C_Item.GetItemIconByID(itemID)
        local _,_,_,_,_,_,_,itemStackCount = C_Item.GetItemInfo(itemID)
        EasyReminders.DataCache[itemID] = {itemID, itemName, itemIcon, nil, itemStackCount}
    end
    for i, data in pairs(EasyReminders.FoodCache)  do
        local itemID = data.itemID
        local itemName = C_Item.GetItemNameByID(itemID)
        local itemIcon = C_Item.GetItemIconByID(itemID)
        local _,_,_,_,_,_,_,itemStackCount = C_Item.GetItemInfo(itemID)
        EasyReminders.DataCache[itemID] = {itemID, itemName, itemIcon, nil, itemStackCount}
    end
    for i, data in pairs(EasyReminders.GearConsumablesCache) do
        local itemID = data.itemID
        local itemName = C_Item.GetItemNameByID(itemID)
        local itemIcon = C_Item.GetItemIconByID(itemID)
        local _,_,_,_,_,_,_,itemStackCount = C_Item.GetItemInfo(itemID)
        EasyReminders.DataCache[itemID] = {itemID, itemName, itemIcon, nil, itemStackCount}
    end
    for i, data in pairs(EasyReminders.charDB.shopping) do
        local itemID = i
        local itemName = C_Item.GetItemNameByID(itemID)
        local itemIcon = C_Item.GetItemIconByID(itemID)
        local _,_,_,_,_,_,_,itemStackCount = C_Item.GetItemInfo(itemID)
        EasyReminders.DataCache[itemID] = {itemID, itemName, itemIcon, nil, itemStackCount}
    end

    EasyReminders.ConsumableCheck:BuildTrackingList()
    EasyReminders.WellFedCheck:BuildTrackingList()
    EasyReminders.BuffCheck:BuildTrackingList()
    EasyReminders.TemporaryEnchantCheck:BuildTrackingList()

    EasyReminders:CreateTimer()

    EasyReminders.UI.NotificationWindow:CreateNotificationWindow()

    -- Set Up the minimap icon

    EasyReminders.LDB = _G.LibStub("LibDataBroker-1.1"):NewDataObject("EasyReminders", {
        type = "data source",
        text = "EasyReminders",
        icon = "Interface\\Icons\\Spell_holy_borrowedtime",
        OnClick = function(self, button)
            if button == "LeftButton" then
               EasyReminders:OpenGUI()
            elseif button == "RightButton" and _G.IsShiftKeyDown() then
               EasyReminders.globalDB.enabled = not EasyReminders.globalDB.enabled
               EasyReminders:Print(L["Toggled Easy Reminders: "] .. (not EasyReminders.globalDB.enabled and L["Enabled"] or L["Disabled"]))
               EasyReminders.UI.MainWindow:UpdateEnable(EasyReminders.globalDB.enabled)
               EasyReminders:CheckBuffs("REFRESH")
            elseif button == "RightButton" then
               _G.Settings.OpenToCategory( EasyReminders.optionsPage)

            end 
        end,
        OnTooltipShow = function(tooltip)
            tooltip:SetText(L["Easy Reminders"])
            tooltip:AddLine(L["Left click to setup reminders"], 1, 1, 1)
            tooltip:AddLine(L["Right click for options"], 1, 1, 1)
            tooltip:AddLine(L["Shift-right click to enable/disable"], 1, 1, 1)
            tooltip:Show()
        end
    })
    
    EasyReminders.MinimapIcon= _G.LibStub("LibDBIcon-1.0")

    EasyReminders.MinimapIcon:Register("EasyReminders", EasyReminders.LDB, EasyReminders.globalDB.minimap)

    EasyReminders.AceConfig:RegisterOptionsTable("EasyReminders", EasyReminders.UI.Options:GetOptions())
    local _, id = EasyReminders.AceConfigDialog:AddToBlizOptions("EasyReminders", "EasyReminders")
    EasyReminders.optionsPage = id or "EasyReminders"

end

function EasyReminders:OpenGUI(msg)
    if not _G.InCombatLockdown() and not C_ChallengeMode.IsChallengeModeActive() 
      and not C_PvP.IsMatchActive() and not (C_Secrets and C_Secrets.ShouldAurasBeSecret()) then
        if not EasyReminders.MainWindow then
            EasyReminders.MainWindow = EasyReminders.UI.MainWindow:CreateMainWindow()
        end
        EasyReminders.MainWindow:Show()
    end
end

function EasyReminders_OpenGUI()
    EasyReminders:OpenGUI()
end

function EasyReminders:CreateTimer()
     EasyReminders.UpdateTimer = _G.C_Timer.NewTicker(10, function() EasyReminders:CheckBuffs("TIMER") end)
end

function EasyReminders:RegisterEvents()
    local f = _G.CreateFrame("Frame", "EasyRemindersBackgroundFrame")
    f:RegisterEvent("BAG_UPDATE_DELAYED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_AURA")
    f:RegisterEvent("ZONE_CHANGED")
    f:RegisterEvent("ZONE_CHANGED_INDOORS")
    f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    f:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
    f:SetScript("OnEvent", EasyReminders.EventHandler)
end

function EasyReminders.EventHandler(self, event, arg1, arg2, arg3, arg4, ...)
    if "PLAYER_ENTERING_WORLD" == event then
        local newInInstance = _G.IsInInstance()
        local _, instanceType = _G.GetInstanceInfo()
    
        if newInInstance and ("interior" == instanceType or "neighborhood" == instanceType) then
            newInInstance = false
        end
        if arg1 or arg2 then
            EasyReminders.BagCache:RefreshBags(false)
            EasyReminders:CheckBuffs("LOGIN")
        elseif not newInInstance and inInstance then -- TODO: Exclude Garrison and hosue exits!
            EasyReminders:CheckBuffs("INSTANCE_EXIT")
        else 
            EasyReminders:CheckBuffs("ZONE_CHANGE")
        end
        inInstance = newInInstance
    elseif "BAG_UPDATE_DELAYED" == event then
        EasyReminders.BagCache:RefreshBags(true)
        EasyReminders:CheckBuffs("ON_USE")
    elseif "UNIT_AURA" == event and "player" == arg1 then
        EasyReminders:CheckBuffs("BUFF_CHANGE")
    elseif "PLAYER_REGEN_ENABLED" == event then
        EasyReminders:CheckBuffs("COMBAT_EXIT")
    elseif "ZONE_CHANGED" == event or "ZONE_CHANGED_INDOORS" == event or "ZONE_CHANGED_NEW_AREA" == event 
        or "PLAYER_ENTERING_BATTLEGROUND" == event then
        local newInInstance = _G.IsInInstance()
        local _, instanceType = _G.GetInstanceInfo()

        -- Do not count Homes
        if newInInstance and ("interior" == instanceType or "neighborhood" == instanceType) then
            newInInstance = false
        end
        if not newInInstance and inInstance then
            EasyReminders:CheckBuffs("INSTANCE_EXIT")
        else 
            EasyReminders:CheckBuffs("ZONE_CHANGE")
        end
        inInstance = newInInstance
    end
end

function EasyReminders:RefreshItem(itemID, success) 
  if success and (EasyReminders.ConsumableCache[itemID] or EasyReminders.FoodCache[itemID]) then
    local itemName = C_Item.GetItemNameByID(itemID)
    local itemIcon = C_Item.GetItemIconByID(itemID)
    local _,_,_,_,_,_,_,itemStackCount = C_Item.GetItemInfo(itemID)
    EasyReminders.DataCache[itemID] = {itemID, itemName, itemIcon, nil, itemStackCount}
  end
end

function EasyReminders:CheckBuffs(cause)

    -- Early out if disabled
    if not EasyReminders.globalDB.enabled then
        EasyReminders.UI.NotificationWindow:UpdateNotifications({})
        EasyReminders.UI.HolidayWindow:HideHolidayWindow()
        EasyReminders.UI.ShoppingWindow:HideShoppingWindow()
        return
    end

    local missingBuffs = {}

    EasyReminders.ConsumableCheck:CheckBuffs(missingBuffs)
    EasyReminders.WellFedCheck:CheckBuffs(missingBuffs)
    EasyReminders.BuffCheck:CheckBuffs(missingBuffs)
    EasyReminders.EnchantCheck:CheckEnchants(missingBuffs)
    EasyReminders.GemCheck:CheckGems(missingBuffs)
    EasyReminders.TemporaryEnchantCheck:CheckEnchants(missingBuffs)
    EasyReminders.DurabilityCheck:CheckDurability(missingBuffs)
    EasyReminders.UI.NotificationWindow:UpdateNotifications(missingBuffs)

    if not HolidayFrame then 
        HolidayFrame = EasyReminders.UI.HolidayWindow:CreateHolidayWindow()
    end

    if not ShoppingFrame then
        ShoppingFrame = EasyReminders.UI.ShoppingWindow:CreateShoppingWindow()
    end
    
    EasyReminders.UI.HolidayWindow:UpdateNotifications()
    EasyReminders.UI.ShoppingWindow:UpdateNotifications(cause)

    -- reprime cache if needed:

    for i, data in pairs(EasyReminders.ConsumableCache) do
        if not EasyReminders.DataCache[data.itemID] or not EasyReminders.DataCache[data.itemID][2] then
            C_Item.GetItemNameByID(data.itemID)
        end
    end
    for i, data in pairs(EasyReminders.FoodCache)  do
        if not EasyReminders.DataCache[data.itemID] or not EasyReminders.DataCache[data.itemID][2] then
            C_Item.GetItemNameByID(data.itemID)
        end
    end
    for i, data in pairs(EasyReminders.GearConsumablesCache)  do
        if not EasyReminders.DataCache[data.itemID] or not EasyReminders.DataCache[data.itemID][2] then
            C_Item.GetItemNameByID(data.itemID)
        end
    end
     for itemId, _ in pairs(EasyReminders.charDB.shopping) do
        if not EasyReminders.DataCache[itemId] or not EasyReminders.DataCache[itemId][2] then
            C_Item.GetItemNameByID(itemId)
        end
    end
    
end

function EasyReminders:ConcatenateTables(table1, table2)
    local outputTable = {}

    for k, data in pairs(table1) do
        outputTable[k] = data
    end
    
    for k, data in pairs(table2) do
        outputTable[k] = data
    end
    return outputTable
end
