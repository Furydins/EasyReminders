EasyReminders = _G.LibStub("AceAddon-3.0"):NewAddon("EasyReminders", "AceConsole-3.0")

EasyReminders.sessionDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersDB")
EasyReminders.AceGUI = _G.LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("EasyReminders")

EasyReminders.MainWindow = nil

function EasyReminders:OnInitialize()
    EasyReminders:RegisterChatCommand("er", "OpenGUI")
    EasyReminders:RegisterChatCommand("easyreminders", "OpenGUI")
    EasyReminders.MainWindow = EasyReminders.UI.MainWindow:CreateMainWindow()
end

function EasyReminders:OpenGUI(msg)
    if msg == "ping" then
        EasyReminders:Print(L["Pong!"])
    else
        EasyReminders.MainWindow:Show()
    end
end

-- TO DO
-- Create Slash command
-- Create GUI for potions
-- Create tracker and test
-- Add Minimap button
-- Addon compartment
-- Add raid buffs tab
-- Add personal buffs tab
-- Add profiles
-- Add holidays trackers
-- Add calenar reminders