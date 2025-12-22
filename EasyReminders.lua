EasyReminders = _G.LibStub("AceAddon-3.0"):NewAddon("EasyReminders", "AceConsole-3.0")

EasyReminders.AceGUI = _G.LibStub("AceGUI-3.0")


local L = LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

EasyReminders.MainWindow = nil

EasyReminders.Font = "Fonts\\FRIZQT__.TTF"

function EasyReminders:OnInitialize()

     -- Initialise Database
    EasyReminders.globalDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersDB").global
    EasyReminders.charDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersCharDB").char

    EasyReminders.charDB.potions = EasyReminders.charDB.potions or {}
    EasyReminders.globalDB.potionsCache = EasyReminders.globalDB.potionsCache or {}

    EasyReminders:RegisterChatCommand("er", "OpenGUI")
    EasyReminders:RegisterChatCommand("easyreminders", "OpenGUI")

    EasyReminders.MainWindow = EasyReminders.UI.MainWindow:CreateMainWindow()

    EasyReminders:RegisterEvents()

    EasyReminders.ConsumableCheck:BuildTrackingList()

    EasyReminders:CreateTimer()

end

function EasyReminders:OpenGUI(msg)
    EasyReminders.UI.MainWindow:RefreshData()
    EasyReminders.MainWindow:Show()
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

-- TO DO
-- Create tracker and test
-- add tracker UI
-- Add Minimap button
-- Addon compartment
-- v1 ready!!!
-- Add raid buffs tab
-- Add personal buffs tab
-- Add profiles
-- Add holidays trackers
-- Add calenar reminders
-- Add restock reminders