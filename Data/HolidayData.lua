EasyReminders.Data = EasyReminders.Data or {}

EasyReminders.Data.Holidays = {

    -- Holiday ids come from Holidays.dbc - holiday name Ids can be decoded from HolidayNames.dbc
    -- Anniversary event changes every year!

    [1] = {["name"] = L["Darkmoon Faire"], ["holidayID"] = 479},

    [2] = {["name"] = L["Lunar Festival"], ["holidayID"] = 327},
    [3] = {["name"] = L["Love is in the Air"], ["holidayID"] = 423},
    [4] = {["name"] = L["Noblegarden"], ["holidayID"] = 181},
    [5] = {["name"] = L["Children's Week"], ["holidayID"] = 201},
    [6] = {["name"] = L["Midsummer Fire Festival"], ["holidayID"] = 341},
    [7] = {["name"] = L["Pirates' Day"], ["holidayID"] = 398},
    [8] = {["name"] = L["Brewfest"], ["holidayID"] = 372},
    [9] = {["name"] = L["Harvest Festival"], ["holidayID"] = 321},
    [10] = {["name"] = L["Hallow's End"], ["holidayID"] = 324},
    [11] = {["name"] = L["Day of the Dead"], ["holidayID"] = 409},
    [12] = {["name"] = L["Anniversary Event"], ["holidayID"] = 1501}, -- Last years anniversary event id - 2026 not in game yet
    [13] = {["name"] = L["Pilgrim's Bounty"], ["holidayID"] = 404},
    [14] = {["name"] = L["Feast of Winter Veil"], ["holidayID"] = 141},

    -- Micro Holidays
    [15] = {["name"] = L["Call of the Scarab"], ["holidayID"] = 638},
    [16] = {["name"] = L["Hatching of the Hippogryphs"], ["holidayID"] = 634},
    [17] = {["name"] = L["Un'Goro Madness"], ["holidayID"] = 644},
    [18] = {["name"] = L["March of the Tadpoles"], ["holidayID"] = 647}, 
    [19] = {["name"] = L["Volunteer Guard Day"], ["holidayID"] = 635},
    [20] = {["name"] = L["Spring Balloon Festival"], ["holidayID"] = 645}, 
    [21] = {["name"] = L["Glowcap Festival"], ["holidayID"] = 648},
    [22] = {["name"] = L["Thousand Boat Bash"], ["holidayID"] = 642},
    [23] = {["name"] = L["Luminous Luminaries"], ["holidayID"] = 1062},
    [24] = {["name"] = L["Auction House Dance Party"], ["holidayID"] = 692},
    [25] = {["name"] = L["Trial of Style"], ["holidayID"] = 691},
    [26] = {["name"] = L["Great Gnomeregan Run"], ["holidayID"] = 696},
    [27] = {["name"] = L["Moonkin Festival"], ["holidayID"] = 694},
    
}

EasyReminders.Data.HolidayMode = {}

EasyReminders.Data.HolidayMode.NEVER = 0
EasyReminders.Data.HolidayMode.ONCE = 1
EasyReminders.Data.HolidayMode.DAILY = 2