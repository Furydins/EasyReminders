EasyReminders.Data = EasyReminders.Data or {}


EasyReminders.Data.HolidayMode = {}

EasyReminders.Data.HolidayMode.NEVER = 0
EasyReminders.Data.HolidayMode.ONCE = 1
EasyReminders.Data.HolidayMode.DAILY = 2

EasyReminders.Data.Duration = {}

EasyReminders.Data.Duration.ANNUAL = 300 
EasyReminders.Data.Duration.MONTHLY = 24 

EasyReminders.Data.HolidayCategories = {}
EasyReminders.Data.HolidayCategories.MAJOR = "MAJOR"
EasyReminders.Data.HolidayCategories.MICRO = "MICRO"
EasyReminders.Data.HolidayCategories.BRAWL = "BRAWL"
EasyReminders.Data.HolidayCategories.TIMEWALKING = "TIMEWALKING"
EasyReminders.Data.HolidayCategories.SKYRIDING = "SKYRIDING"
EasyReminders.Data.HolidayCategories.OTHER = "OTHER"

EasyReminders.Data.Holidays = {

    -- Holiday ids come from Holidays.dbc - holiday name Ids can be decoded from HolidayNames.dbc
    -- Anniversary event changes every year!

    [1] = {["name"] = L["Darkmoon Faire"], ["holidayID"] = 479,  ["category"] = EasyReminders.Data.HolidayCategories.OTHER},

    [2] = {["name"] = L["Lunar Festival"], ["holidayID"] = 327,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [3] = {["name"] = L["Love is in the Air"], ["holidayID"] = 423,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [4] = {["name"] = L["Noblegarden"], ["holidayID"] = 181,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [5] = {["name"] = L["Children's Week"], ["holidayID"] = 201,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [6] = {["name"] = L["Midsummer Fire Festival"], ["holidayID"] = 341,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [7] = {["name"] = L["Pirates' Day"], ["holidayID"] = 398,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [8] = {["name"] = L["Brewfest"], ["holidayID"] = 372,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [9] = {["name"] = L["Harvest Festival"], ["holidayID"] = 321,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [10] = {["name"] = L["Hallow's End"], ["holidayID"] = 324,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [11] = {["name"] = L["Day of the Dead"], ["holidayID"] = 409,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [12] = {["name"] = L["Anniversary Event"], ["holidayID"] = 1808,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR}, 
    [13] = {["name"] = L["Pilgrim's Bounty"], ["holidayID"] = 404,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [14] = {["name"] = L["Feast of Winter Veil"], ["holidayID"] = 141,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    -- Micro Holidays
    [15] = {["name"] = L["Call of the Scarab"], ["holidayID"] = 638,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [16] = {["name"] = L["Hatching of the Hippogryphs"], ["holidayID"] = 634,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [17] = {["name"] = L["Un'Goro Madness"], ["holidayID"] = 644,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [18] = {["name"] = L["March of the Tadpoles"], ["holidayID"] = 647,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO}, 
    [19] = {["name"] = L["Volunteer Guard Day"], ["holidayID"] = 635,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [20] = {["name"] = L["Spring Balloon Festival"], ["holidayID"] = 645,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO}, 
    [21] = {["name"] = L["Glowcap Festival"], ["holidayID"] = 648,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [22] = {["name"] = L["Thousand Boat Bash"], ["holidayID"] = 642,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [55] = {["name"] = L["Darkspear Dash"], ["holidayID"] = 1793, ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [23] = {["name"] = L["Luminous Luminaries"], ["holidayID"] = 1062,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [24] = {["name"] = L["Auction House Dance Party"], ["holidayID"] = 692,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [25] = {["name"] = L["Trial of Style"], ["holidayID"] = 691,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [26] = {["name"] = L["Great Gnomeregan Run"], ["holidayID"] = 696,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [27] = {["name"] = L["Moonkin Festival"], ["holidayID"] = 694,  ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    
    -- Timewwalking
    [28] = {["name"] = L["Classic Timewalking"], ["holidayID"] = 1508, otherIds = {1583, 1584, 1585}, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [29] = {["name"] = L["BC Timewalking"], ["holidayID"] = 559, otherIds = {622, 623, 624}, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [30] = {["name"] = L["Wrath Timewalking"], ["holidayID"] = 562, otherIds = {616, 617, 618}, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [31] = {["name"] = L["Cataclysm Timewalking"], ["holidayID"] = 587, otherIds = {628, 629, 630}, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [32] = {["name"] = L["Mists Timewalking"], ["holidayID"] = 643, otherIds = {652, 654, 656}, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [33] = {["name"] = L["Warlords Timewalking"], ["holidayID"] = 1056, otherIds = {1063, 1065, 1068}, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [34] = {["name"] = L["Legion Timewalking"], ["holidayID"] = 1263, otherIds = {1265, 1267, 1269, 1271}, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [35] = {["name"] = L["BfA Timewalking"], ["holidayID"] = 1666, otherIds = {1667, 1668, 1669}, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [36] = {["name"] = L["Shadowlands Timewalking"], ["holidayID"] = 1703, otherIds = {1704, 1705, 1706, 1707, 1708, 1709, 1710}, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [54] = {["name"] = L["Dragonflight Timewalking"], ["holidayID"] = 1719, otherIds = {1720, 1721, 1722}, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},

    -- Brawls
    [37] = {["name"] = L["Brawl: Arathi Blizzard"], ["holidayID"] = 666, otherIds = {673, 680, 687, 737}, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [38] = {["name"] = L["Brawl: Classic Ashran"], ["holidayID"] = 1120, otherIds = {1121, 1122, 1123, 1124}, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [40] = {["name"] = L["Brawl: Cooking Impossible"], ["holidayID"] = 1047, otherIds = {1048, 1049, 1050, 1051}, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [41] = {["name"] = L["Brawl: Deep Six"], ["holidayID"] = 702, otherIds = {704, 105, 706, 736}, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [42] = {["name"] = L["Brawl: Cooking Impossible"], ["holidayID"] = 1047, otherIds = {1048, 1049, 1050, 1051}, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [43] = {["name"] = L["Brawl: Deepwind Dunk"], ["holidayID"] = 1239, otherIds = {1240, 1241, 1242, 1243}, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [44] = {["name"] = L["Brawl: Gravity Lapse"], ["holidayID"] = 659, otherIds = {663, 670, 677, 684}, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [45] = {["name"] = L["Brawl: Packed House"], ["holidayID"] = 667, otherIds = {674, 681, 688, 701}, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [46] = {["name"] = L["Brawl: Shado-Pan Showdown"], ["holidayID"] = 1232, otherIds = {1233, 1244, 1245, 1246}, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [47] = {["name"] = L["Brawl: Southshore v Tarren Mill"], ["holidayID"] = 660, otherIds = {662, 669, 676, 683}, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [48] = {["name"] = L["Brawl: Temple of Hotmogu"], ["holidayID"] = 1166, otherIds = {1167, 1168, 1168, 1170}, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [49] = {["name"] = L["Brawl: Warsong Scramble"], ["holidayID"] = 664, otherIds = {671, 678, 685, 1221}, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},

    -- Skyriding
    [50] = {["name"] = L["Skyriding Cup - Kalimdor"], ["holidayID"] = 1395, ["category"] = EasyReminders.Data.HolidayCategories.SKYRIDING},
    [51] = {["name"] = L["Skyriding Cup - Eastern Kingdoms"], ["holidayID"] = 1400, ["category"] = EasyReminders.Data.HolidayCategories.SKYRIDING},
    [52] = {["name"] = L["Skyriding Cup - Outland"], ["holidayID"] = 1407, ["category"] = EasyReminders.Data.HolidayCategories.SKYRIDING},
    [53] = {["name"] = L["Skyriding Cup - Northrend"], ["holidayID"] = 1429, ["category"] = EasyReminders.Data.HolidayCategories.SKYRIDING},

}

EasyReminders.Data.HolidayOrder = {
    [1] = 1, -- Darkmoon Faire
    [2] = 2, -- Lunar Festival
    [3] = 3, -- Love is in the Air
    [4] = 4, -- Noblegarden
    [5] = 5, -- Children's Week
    [6] = 6, -- Midsummer Fire Festival
    [7] = 7, -- Pirates' Day
    [8] = 8, -- Brewfest
    [9] = 9, -- Harvest Festival
    [10] = 10, -- Hallow's End
    [11] = 11, -- Day of the Dead
    [12] = 12, -- Anniversary Event
    [13] = 13, -- Pilgrim's Bounty
    [14] = 14, -- Feast of Winter Veil

    [15] = 15, -- Call of the Scarab
    [16] = 16, -- Hatching of the Hippogryphs
    [17] = 17, -- Un'Goro Madness
    [18] = 18, -- March of the Tadpoles
    [19] = 19, -- Volunteer Guard Day
    [20] = 20, -- Spring Balloon Festival
    [21] = 21, -- Glowcap Festival
    [22] = 22, -- Thousand Boat Bash
    [23] = 55, -- Darkspear Dash
    [24] = 23, -- Luminous Luminaries
    [25] = 24, -- Auction House Dance Party
    [26] = 25, -- Trial of Style
    [27] = 26, -- Great Gnomeregan Run
    [28] = 27, -- Moonkin Festival

    [29] = 28, -- Classic Timewalking
    [30] = 29, -- BC Timewalking
    [31] = 30, -- Wrath Timewalking
    [32] = 31, -- Cataclysm Timewalking
    [33] = 32, -- Mists Timewalking
    [34] = 33, -- Warlords Timewalking
    [35] = 34, -- Legion Timewalking
    [36] = 35, -- BfA Timewalking
    [37] = 36, -- Shadowlands Timewalking
    [38] = 54, -- Dragonflight Timewalking

    [39] = 37, -- Brawl: Arathi Blizzard
    [40] = 38, -- Brawl: Classic Ashran
    [41] = 40, -- Brawl: Cooking Impossible
    [42] = 41, -- Brawl: Deep Six
    [43] = 42, -- Brawl: Cooking Impossible
    [44] = 43, -- Brawl: Deepwind Dunk
    [45] = 44, -- Brawl: Gravity Lapse
    [46] = 45, -- Brawl: Packed House
    [47] = 46, -- Brawl: Shado-Pan Showdown
    [48] = 47, -- Brawl: Southshore v Tarren Mill
    [49] = 48, -- Brawl: Temple of Hotmogu
    [50] = 49, -- Brawl: Warsong Scramble

    [51] = 50, -- Skyriding Cup - Kalimdor
    [52] = 51, -- Skyriding Cup - Eastern Kingdoms
    [53] = 52, -- Skyriding Cup - Outland
    [54] = 53, -- Skyriding Cup - Northrend

}
