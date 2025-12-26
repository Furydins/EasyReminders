EasyReminders = _G.LibStub("AceAddon-3.0"):NewAddon("EasyReminders", "AceConsole-3.0")

EasyReminders.AceGUI = _G.LibStub("AceGUI-3.0")


local L = LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

EasyReminders.MainWindow = nil
EasyReminders.Font = "Fonts\\FRIZQT__.TTF"

EasyReminders.NotificationWindow = nil

EasyReminders.DataCache = {}
EasyReminders.ConsumableCache = {}

function EasyReminders:OnInitialize()

     -- Initialise Database
    EasyReminders.globalDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersDB").global
    EasyReminders.charDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersCharDB").char

    EasyReminders.charDB.potions = EasyReminders.charDB.potions or {}
    EasyReminders.globalDB.customConsumables = EasyReminders.globalDB.customConsumables or {}


    EasyReminders:RegisterChatCommand("er", "OpenGUI")
    EasyReminders:RegisterChatCommand("easyreminders", "OpenGUI")

    EasyReminders.ConsumableCache = EasyReminders:ConcatenateTables(EasyReminders.Data.Consumables, EasyReminders.globalDB.customConsumables)
    EasyReminders.MainWindow = EasyReminders.UI.MainWindow:CreateMainWindow()

    EasyReminders:RegisterEvents()

    EasyReminders.ConsumableCheck:BuildTrackingList()

    EasyReminders:CreateTimer()
    
    EasyReminders.UI.NotificationWindow:CreateNotificationWindow()
    

end

function EasyReminders:OpenGUI(msg)
    if msg and string.len(msg) > 0 then
        for k,v in pairs(EasyReminders.ConsumableCheck:GetBagCache()) do
            EasyReminders:Print( "Item..", k, v)
        end
        local bagCache = EasyReminders.ConsumableCheck:GetBagCache()
        EasyReminders:Print("In bag: ", msg, bagCache[msg])
    else
        EasyReminders.UI.MainWindow:RefreshData()
        EasyReminders.MainWindow:Show()
    end
end

function EasyReminders:CreateTimer()
    EasyReminders.Print("Creating update timer...")
     EasyReminders.UpdateTimer = _G.C_Timer.NewTicker(10, function() EasyReminders.ConsumableCheck:CheckBuffs() end)
end

function EasyReminders:RegisterEvents()
    local f = _G.CreateFrame("Frame", "EasyRemindersBackgroundFrame")
    f:RegisterEvent("UNIT_INVENTORY_CHANGED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_AURA")
    f:SetScript("OnEvent", EasyReminders.EventHandler)
end

function EasyReminders.EventHandler(self, event, arg1, arg2, arg3, arg4, ...)
    if "PLAYER_ENTERING_WORLD" == event then
        if arg2 then
            EasyReminders.ConsumableCheck:GetBagItems()
        end
        EasyReminders.ConsumableCheck:CheckBuffs()
    elseif "UNIT_INVENTORY_CHANGED" == event and not issecretvalue(arg1) and "player" == arg1 then
        EasyReminders.ConsumableCheck:GetBagItems()
    elseif "UNIT_AURA" == event and not issecretvalue(arg1) and "player" == arg1 then
        EasyReminders.ConsumableCheck:CheckBuffs()
    elseif "PLAYER_REGEN_ENABLED" == event then
        EasyReminders.ConsumableCheck:CheckBuffs()
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

-- TO DO
-- Custom items
-- Delete button for custom items
-- add actual items!
-- Add Minimap button
-- Addon compartment
-- icon
-- PvP option
-- Test bags
-- Test secrets
-- Anchor
-- Visual customization
-- Localizations
-- Sorting
-- v1 ready!!!
-- Add raid buffs tab
-- Add personal buffs tab
-- Add profiles
-- Add holidays trackers
-- Add calenar reminders
-- Add restock reminders