EasyReminders.Data = EasyReminders.Data or {}


EasyReminders.Data.HolidayMode = {}

EasyReminders.Data.HolidayMode.NEVER = 0
EasyReminders.Data.HolidayMode.ONCE = 1
EasyReminders.Data.HolidayMode.DAILY = 2

EasyReminders.Data.Duration = {}

EasyReminders.Data.Duration.ANNUAL = 300 
EasyReminders.Data.Duration.MONTHLY = 24 

EasyReminders.Data.Holidays = {

    -- Holiday ids come from Holidays.dbc - holiday name Ids can be decoded from HolidayNames.dbc
    -- Anniversary event changes every year!

    [1] = {["name"] = L["Darkmoon Faire"], ["holidayID"] = 479, ["duration"] = EasyReminders.Data.Duration.MONTHLY},

    [2] = {["name"] = L["Lunar Festival"], ["holidayID"] = 327, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [3] = {["name"] = L["Love is in the Air"], ["holidayID"] = 423, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [4] = {["name"] = L["Noblegarden"], ["holidayID"] = 181, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [5] = {["name"] = L["Children's Week"], ["holidayID"] = 201, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [6] = {["name"] = L["Midsummer Fire Festival"], ["holidayID"] = 341, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [7] = {["name"] = L["Pirates' Day"], ["holidayID"] = 398, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [8] = {["name"] = L["Brewfest"], ["holidayID"] = 372, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [9] = {["name"] = L["Harvest Festival"], ["holidayID"] = 321, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [10] = {["name"] = L["Hallow's End"], ["holidayID"] = 324, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [11] = {["name"] = L["Day of the Dead"], ["holidayID"] = 409, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [12] = {["name"] = L["Anniversary Event"], ["holidayID"] = 1501, ["duration"] = EasyReminders.Data.Duration.ANNUAL}, -- Last years anniversary event id - 2026 not in game yet
    [13] = {["name"] = L["Pilgrim's Bounty"], ["holidayID"] = 404, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [14] = {["name"] = L["Feast of Winter Veil"], ["holidayID"] = 141, ["duration"] = EasyReminders.Data.Duration.ANNUAL},

    -- Micro Holidays
    [15] = {["name"] = L["Call of the Scarab"], ["holidayID"] = 638, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [16] = {["name"] = L["Hatching of the Hippogryphs"], ["holidayID"] = 634, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [17] = {["name"] = L["Un'Goro Madness"], ["holidayID"] = 644, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [18] = {["name"] = L["March of the Tadpoles"], ["holidayID"] = 647, ["duration"] = EasyReminders.Data.Duration.ANNUAL}, 
    [19] = {["name"] = L["Volunteer Guard Day"], ["holidayID"] = 635, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [20] = {["name"] = L["Spring Balloon Festival"], ["holidayID"] = 645, ["duration"] = EasyReminders.Data.Duration.ANNUAL}, 
    [21] = {["name"] = L["Glowcap Festival"], ["holidayID"] = 648, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [22] = {["name"] = L["Thousand Boat Bash"], ["holidayID"] = 642, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [23] = {["name"] = L["Luminous Luminaries"], ["holidayID"] = 1062, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [24] = {["name"] = L["Auction House Dance Party"], ["holidayID"] = 692, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [25] = {["name"] = L["Trial of Style"], ["holidayID"] = 691, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [26] = {["name"] = L["Great Gnomeregan Run"], ["holidayID"] = 696, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    [27] = {["name"] = L["Moonkin Festival"], ["holidayID"] = 694, ["duration"] = EasyReminders.Data.Duration.ANNUAL},
    
}

