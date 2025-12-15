EasyReminders = _G.LibStub("AceAddon-3.0"):NewAddon("EasyReminders", "AceConsole-3.0")

EasyReminders.sessionDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersDB")
EasyReminders.AceGUI = _G.LibStub("AceGUI-3.0")


function EasyReminders:OnInitialize()
    EasyReminders:RegisterChatCommand("er", "OpenGUI")
    EasyReminders:RegisterChatCommand("easyreminders", "OpenGUI")
end

function EasyReminders:OpenGU()
    if msg == "ping" then
        EasyReminders:Print("Pong!")
    else
        EasyReminders:Print("Hello There!")
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