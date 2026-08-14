EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.ShoppingWindow = EasyReminders.UI.ShoppingWindow or {}

local ShoppingWindow = EasyReminders.UI.ShoppingWindow

local frame
local shownShoppingItems = {}

local trackedItems = {}

local loginPending = 2

local currentZone = 0

local function hasValue(tab, value)
    for k,v in pairs(tab) do
        if v == value then
            return true
        end
    end
    return false
end

local function setCloseOnEscPress(window)
   local oldCloseSpecialWindows = CloseSpecialWindows
    CloseSpecialWindows = function()
		if window:IsShown() then
			window:Hide()
			return true
		end

		return oldCloseSpecialWindows()
	end
end

function ShoppingWindow:CreateShoppingWindow()

    frame = EasyReminders.AceGUI:Create("Window")
    frame:SetTitle(L["Shopping List"])
    frame:SetWidth(480)
    frame:SetHeight(300)
    frame:SetLayout("List")
    frame:SetAutoAdjustHeight(true)
    frame.frame:SetFrameStrata("MEDIUM")
     if not EasyReminders.globalDB.shoppingLocation then
        frame:SetPoint("TOP", _G.UIParent, "CENTER", 0, 300)
    else
        frame:SetPoint(EasyReminders.globalDB.shoppingLocation[1], 
                _G.UIParent, EasyReminders.globalDB.shoppingLocation[3], EasyReminders.globalDB.shoppingLocation[4], 
               EasyReminders.globalDB.shoppingLocation[5])
    end
    frame.frame:SetMovable(true)
    ShoppingWindow:StorePositon()
    frame.frame:Hide()

    --- drag suport

   frame.frame:SetScript("OnMouseDown", function(this, button)
        if button == "LeftButton" and not EasyReminders.globalDB.lock then
            this:StartMoving()
        end
    end)
    frame.frame:SetScript("OnMouseUp", function(this, button)
        if button == "LeftButton" then
            this:StopMovingOrSizing()
            ShoppingWindow:StorePositon()
        end
    end)
  
    return frame
end

local function GetMissingItems()
    local missingItems = {}

    for itemId, minQuantity in pairs(EasyReminders.charDB.shopping) do
        local itemcount = C_Item.GetItemCount(itemId, false, true) or 0
        local cacheEntry = EasyReminders.DataCache[itemId] or {}
        local itemName = cacheEntry[2] or C_Item.GetItemNameByID(itemId)
        local itemIcon = cacheEntry[3] or C_Item.GetItemIconByID(itemId)
         if itemcount < minQuantity then
            missingItems[itemId] = {["name"] = itemName, ["icon"] = itemIcon, ["missingCount"] = minQuantity - itemcount}
        end
    end

    return missingItems
end

local function recordTrackedItems()
    trackedItems = {}
    for itemId, minQuantity in pairs(EasyReminders.charDB.shopping) do
        local itemcount =  C_Item.GetItemCount(itemId, false, true) or 0
        trackedItems[itemId] = itemcount
    end
end

local function wasTrackedItemUsed()
    for itemId, oldCount in pairs(trackedItems) do
        local newCount = C_Item.GetItemCount(itemId, false, true) or 0
        if oldCount and (newCount < oldCount) then
            return true
        end
    end
    return false
end

function ShoppingWindow:UpdateNotifications(type)

    local _type = type

    -- Delay login check to allow time
    -- to cache bag contents
    if _type== "LOGIN" then
        loginPending = 2
       return
    elseif loginPending > 1 then
        if _type == "TIMER" then
            loginPending = loginPending - 1
        end 
        return
    elseif loginPending == 1 and type == "TIMER" then
        _type= "LOGIN"
        loginPending = 0
    end

    if "ZONE_CHANGE" == type then
        local zoneID = C_Map.GetBestMapForUnit("player")
        if currentZone ~= zoneID then
            currentZone = zoneID
             if zoneID and EasyReminders.Data.Locations.AuctionHouseZones[zoneID] then
                _type = "NEAR_AH"
            else
                _type = "IGNORE"
            end
        else
            _type = "IGNORE"
        end
       
    end

    if not _G.InCombatLockdown() and not C_ChallengeMode.IsChallengeModeActive() 
    and not C_PvP.IsMatchActive() and not (C_Secrets and C_Secrets.ShouldAurasBeSecret()) then

        -- Only check for ON_USE if one of our tracked items was used
        -- Otherwise we end up with false alarms
        if EasyReminders.charDB.shoppingNotifications.ON_USE then
            if ("ON_USE" == type) and wasTrackedItemUsed() then
                _type = "ON_USE"
            elseif "ON_USE" == type then
                _type = "IGNORE"
            end
            recordTrackedItems()
        end

        -- Punt if not the right notification type
        if not EasyReminders.charDB.shoppingNotifications[_type] then
            return 
        end

        local missingItems = GetMissingItems()

        local shouldShow = false

        frame:ReleaseChildren()

        shownShoppingItems = {}    
        local masterDismiss = EasyReminders.AceGUI:Create("Button")
        masterDismiss:SetText(L["Dismiss All"])
        masterDismiss:SetWidth(450)
        masterDismiss:SetCallback("OnClick", function(widget)
            ShoppingWindow:DimissAll(shownShoppingItems)
            frame.frame:Hide()
        end)
        frame:AddChild(masterDismiss)

        
        for i, data in pairs(missingItems) do
            local group = EasyReminders.AceGUI:Create("SimpleGroup")
            group:SetLayout("flow")
            group:SetFullWidth(true)
            frame:AddChild(group)

            local itemName = EasyReminders.AceGUI:Create("Label")
            itemName:SetText( data.name)
            itemName:SetImage(data.icon)
            itemName:SetFont(EasyReminders.Font, 12, "")
            itemName:SetWidth(300)
            group:AddChild(itemName)


            local dismissButton = EasyReminders.AceGUI:Create("Button")
            dismissButton:SetText(L["Dismiss"])
            dismissButton:SetWidth(140)
            group:AddChild(dismissButton)
            dismissButton:SetCallback("OnClick", function(widget)
                group.frame:Hide()
            end)
            table.insert(shownShoppingItems, group)
            shouldShow = true
        end

        if shouldShow then
            frame.frame:Show()
        else
            frame.frame:Hide()
        end
    end
end

function ShoppingWindow:DimissAll(shownItems)
     for i, data in pairs(shownItems) do
       data.frame:Hide()
    end
end

function ShoppingWindow:HideShoppingWindow()
    if frame then
        frame.frame:Hide()
    end
end

function ShoppingWindow:StorePositon()
    if EasyReminders.globalDB.shoppingLocation == nil then
        EasyReminders.globalDB.shoppingLocation = {}
    end
    point, relativeTo, relativePoint, offsetX, offsetY = frame:GetPoint()
    EasyReminders.globalDB.shoppingLocation[1] = point
    EasyReminders.globalDB.shoppingLocation[3] = relativePoint
    EasyReminders.globalDB.shoppingLocation[4] = offsetX
    EasyReminders.globalDB.shoppingLocation[5] = offsetY
end

