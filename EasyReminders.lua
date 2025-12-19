EasyReminders = _G.LibStub("AceAddon-3.0"):NewAddon("EasyReminders", "AceConsole-3.0")

EasyReminders.AceGUI = _G.LibStub("AceGUI-3.0")


local L = LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

EasyReminders.MainWindow = nil

EasyReminders.Font = "Fonts\\FRIZQT__.TTF"

function EasyReminders:OnInitialize()

     -- Initialise Database
    EasyReminders.sessionDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersDB")
    EasyReminders.charDB = EasyReminders.sessionDB.char
    EasyReminders.globalDB = EasyReminders.sessionDB.global


    EasyReminders.charDB.potions = EasyReminders.charDB.potions or {}
    EasyReminders.globalDB.potionsCache = EasyReminders.globalDB.potionsCache or {}

    EasyReminders:RegisterChatCommand("er", "OpenGUI")
    EasyReminders:RegisterChatCommand("easyreminders", "OpenGUI")

    EasyReminders.MainWindow = EasyReminders.UI.MainWindow:CreateMainWindow()

end



function EasyReminders:OpenGUI(msg)
    EasyReminders.UI.MainWindow:RefreshData()
    EasyReminders.MainWindow:Show()
end

-- TO DO
-- Create GUI for potions
-- Create tracker and test
-- Add Minimap button
-- Addon compartment
-- Add raid buffs tab
-- Add personal buffs tab
-- Add profiles
-- Add holidays trackers
-- Add calenar reminders
-- Add restock reminders