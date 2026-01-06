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

local HolidayFrame = nil

function EasyReminders:OnInitialize()

     -- Initialise Database
    EasyReminders.globalDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersDB").global
    EasyReminders.charDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersCharDB").char

    EasyReminders.charDB.potions = EasyReminders.charDB.potions or {}
    EasyReminders.charDB.food = EasyReminders.charDB.food or {}
    EasyReminders.charDB.buff = EasyReminders.charDB.buff or {}
     EasyReminders.charDB.holiday = EasyReminders.charDB.holiday or {}

    EasyReminders.globalDB.customConsumables = EasyReminders.globalDB.customConsumables or {}
    EasyReminders.globalDB.customFood = EasyReminders.globalDB.customFood or {}
    EasyReminders.globalDB.customBuffs = EasyReminders.globalDB.customBuffs or {}

    EasyReminders:RegisterChatCommand("er", "OpenGUI")
    EasyReminders:RegisterChatCommand("easyreminders", "OpenGUI")

    EasyReminders.ConsumableCache = EasyReminders:ConcatenateTables(EasyReminders.Data.Consumables, EasyReminders.globalDB.customConsumables)
    EasyReminders.FoodCache = EasyReminders:ConcatenateTables(EasyReminders.Data.Food, EasyReminders.globalDB.customFood)
    EasyReminders.BuffCache = EasyReminders:ConcatenateTables(EasyReminders.Data.Buffs, EasyReminders.globalDB.customBuffs)
    
    EasyReminders:RegisterEvents()

    -- Prime Cache
    for i, data in pairs(EasyReminders.Data.Consumables) do
        EasyReminders:AddData(data.itemID)
    end
    for i, data in pairs(EasyReminders.Data.Food)  do
        EasyReminders:AddData(data.itemID)
    end

    EasyReminders.ConsumableCheck:PopulateData()
    EasyReminders.WellFedCheck:PopulateData()

    EasyReminders.ConsumableCheck:BuildTrackingList()
    EasyReminders.WellFedCheck:BuildTrackingList()
    EasyReminders.BuffCheck:BuildTrackingList()

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
            elseif button == "RightButton" then
                _G.Settings.OpenToCategory( EasyReminders.optionsPage)
            end 
        end,
        OnTooltipShow = function(tooltip)
            tooltip:SetText(L["Easy Reminders"])
            tooltip:AddLine(L["Left click to setup reminders"], 1, 1, 1)
            tooltip:AddLine(L["Right click for settings"], 1, 1, 1)
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
    if msg and _G.string.len(msg) > 0 then

        local frame =  EasyReminders.UI.HolidayWindow:CreateHolidayWindow()

        local activeHolidays = {
            [0] = {["name"] = "holidayOne", ["holidayIndex"] = 100, ["duration"] = EasyReminders.Data.Duration.MONTHLY},
            [1] = {["name"] = "holidayTwo", ["holidayIndex"] = 101, ["duration"] = EasyReminders.Data.Duration.MONTHLY},
            [2] = {["name"] = "holidayThree", ["holidayIndex"] = 102,  ["duration"] = EasyReminders.Data.Duration.MONTHLY},
        }
        EasyReminders.UI.HolidayWindow:UpdateNotifications(activeHolidays)
        
    else
        EasyReminders:RefreshData()
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
     EasyReminders.UpdateTimer = _G.C_Timer.NewTicker(10, function() EasyReminders:CheckBuffs() end)
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
        if arg1 or arg2 then
            EasyReminders.BagCache:RefreshBags()
        end
        EasyReminders:CheckBuffs()
    elseif "UNIT_INVENTORY_CHANGED" == event and "player" == arg1 then
        EasyReminders.BagCache:RefreshBags()
    elseif "UNIT_AURA" == event and "player" == arg1 then
        EasyReminders:CheckBuffs()
    elseif "PLAYER_REGEN_ENABLED" == event then
        EasyReminders:CheckBuffs()
    end
end

function EasyReminders:AddData(itemID, itemName, itemIcon, spellInfo)
    local data = EasyReminders.DataCache[itemID] or {}

    data[1] = itemID
    data[2] = itemName or data[2] or nil
    data[3] = itemIcon or data[3] or nil
    data[4] = spellInfo or data[4] or nil

    EasyReminders.DataCache[itemID] = data

end

function EasyReminders:RefreshData()
  for itemID, data in pairs(EasyReminders.DataCache) do

    local itemName = data[2] or C_Item.GetItemNameByID(itemID)
    local itemIcon = data[3] or C_Item.GetItemIconByID(itemID)
    local spellInfo = data[4] or C_Spell.GetSpellInfo(itemID)
    EasyReminders.DataCache[itemID] = {data[1], itemName, itemIcon, spellInfo}

  end
end

function EasyReminders:CheckBuffs()
    EasyReminders:RefreshData()
    local missingBuffs = {}

    EasyReminders.ConsumableCheck:CheckBuffs(missingBuffs)
    EasyReminders.WellFedCheck:CheckBuffs(missingBuffs)
    EasyReminders.BuffCheck:CheckBuffs(missingBuffs)
    EasyReminders.UI.NotificationWindow:UpdateNotifications(missingBuffs)

    if not HolidayFrame then 
        HolidayFrame = EasyReminders.UI.HolidayWindow:CreateHolidayWindow()
    end
    
    EasyReminders.UI.HolidayWindow:UpdateNotifications()
    
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
