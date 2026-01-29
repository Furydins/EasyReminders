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

local loadFrame

function EasyReminders:OnInitialize()

     -- Initialise Database
    EasyReminders.globalDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersDB").global
    EasyReminders.charDB = _G.LibStub("AceDB-3.0"):New("EasyRemindersCharDB").char

    EasyReminders.charDB.potions = EasyReminders.charDB.potions or {}
    EasyReminders.charDB.food = EasyReminders.charDB.food or {}
    EasyReminders.charDB.buff = EasyReminders.charDB.buff or {}
    EasyReminders.charDB.holiday = EasyReminders.charDB.holiday or {}

    EasyReminders.globalDB.enabled = EasyReminders.globalDB.enabled or true
    EasyReminders.globalDB.customConsumables = EasyReminders.globalDB.customConsumables or {}
    EasyReminders.globalDB.customFood = EasyReminders.globalDB.customFood or {}
    EasyReminders.globalDB.customBuffs = EasyReminders.globalDB.customBuffs or {}

    EasyReminders:RegisterChatCommand("er", "OpenGUI")
    EasyReminders:RegisterChatCommand("easyreminders", "OpenGUI")

    EasyReminders.ConsumableCache = EasyReminders:ConcatenateTables(EasyReminders.Data.Consumables, EasyReminders.globalDB.customConsumables)
    EasyReminders.FoodCache = EasyReminders:ConcatenateTables(EasyReminders.Data.Food, EasyReminders.globalDB.customFood)
    EasyReminders.BuffCache = EasyReminders:ConcatenateTables(EasyReminders.Data.Buffs, EasyReminders.globalDB.customBuffs)
    
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
        EasyReminders.DataCache[itemID] = {itemID, itemName, itemIcon, nil}
    end
    for i, data in pairs(EasyReminders.FoodCache)  do
        local itemID = data.itemID
        local itemName = C_Item.GetItemNameByID(itemID)
        local itemIcon = C_Item.GetItemIconByID(itemID)
        EasyReminders.DataCache[itemID] = {itemID, itemName, itemIcon, nil}
    end


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
          -- elseif button == "RightButton" and _G.IsShiftKeyDown() then
          -- _G.Settings.OpenToCategory( EasyReminders.optionsPage)
            elseif button == "RightButton" then
                EasyReminders.globalDB.enabled = not EasyReminders.globalDB.enabled
                EasyReminders:CheckBuffs()
            end 
        end,
        OnTooltipShow = function(tooltip)
            tooltip:SetText(L["Easy Reminders"])
            tooltip:AddLine(L["Left click to setup reminders"], 1, 1, 1)
            tooltip:AddLine(L["Right click to enable/disable"], 1, 1, 1)
            --tooltip:AddLine(L["Shift-right click for options"], 1, 1, 1)
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
     EasyReminders.UpdateTimer = _G.C_Timer.NewTicker(10, function() EasyReminders:CheckBuffs() end)
end

function EasyReminders:RegisterEvents()
    local f = _G.CreateFrame("Frame", "EasyRemindersBackgroundFrame")
    f:RegisterEvent("UNIT_INVENTORY_CHANGED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_AURA")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
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

function EasyReminders:RefreshItem(itemID, success) 
  if success and (EasyReminders.ConsumableCache[itemID] or EasyReminders.FoodCache[itemID]) then
    local itemName = C_Item.GetItemNameByID(itemID)
    local itemIcon = C_Item.GetItemIconByID(itemID)
    EasyReminders.DataCache[itemID] = {itemID, itemName, itemIcon, nil}
  end
end

function EasyReminders:CheckBuffs()

    -- Early out if disabled
    if not EasyReminders.globalDB.enabled then
        EasyReminders.UI.NotificationWindow:UpdateNotifications({})
        EasyReminders.UI.HolidayWindow:HideHolidayWindow()
        return
    end

    local missingBuffs = {}

    EasyReminders.ConsumableCheck:CheckBuffs(missingBuffs)
    EasyReminders.WellFedCheck:CheckBuffs(missingBuffs)
    EasyReminders.BuffCheck:CheckBuffs(missingBuffs)
    EasyReminders.UI.NotificationWindow:UpdateNotifications(missingBuffs)

    if not HolidayFrame then 
        HolidayFrame = EasyReminders.UI.HolidayWindow:CreateHolidayWindow()
    end
    
    EasyReminders.UI.HolidayWindow:UpdateNotifications()

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
