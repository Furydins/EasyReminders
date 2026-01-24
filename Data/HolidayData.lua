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
EasyReminders.Data.HolidayCategories.OTHER = "OTHER"

EasyReminders.Data.Holidays = {

    -- Holiday ids come from Holidays.dbc - holiday name Ids can be decoded from HolidayNames.dbc
    -- Anniversary event changes every year!

    [1] = {["name"] = L["Darkmoon Faire"], ["holidayID"] = 479, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.OTHER},

    [2] = {["name"] = L["Lunar Festival"], ["holidayID"] = 327, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [3] = {["name"] = L["Love is in the Air"], ["holidayID"] = 423, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [4] = {["name"] = L["Noblegarden"], ["holidayID"] = 181, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [5] = {["name"] = L["Children's Week"], ["holidayID"] = 201, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [6] = {["name"] = L["Midsummer Fire Festival"], ["holidayID"] = 341, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [7] = {["name"] = L["Pirates' Day"], ["holidayID"] = 398, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [8] = {["name"] = L["Brewfest"], ["holidayID"] = 372, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [9] = {["name"] = L["Harvest Festival"], ["holidayID"] = 321, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [10] = {["name"] = L["Hallow's End"], ["holidayID"] = 324, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [11] = {["name"] = L["Day of the Dead"], ["holidayID"] = 409, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [12] = {["name"] = L["Anniversary Event"], ["holidayID"] = 1501, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR}, -- Last years anniversary event id - 2026 not in game yet
    [13] = {["name"] = L["Pilgrim's Bounty"], ["holidayID"] = 404, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [14] = {["name"] = L["Feast of Winter Veil"], ["holidayID"] = 141, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    -- Micro Holidays
    [15] = {["name"] = L["Call of the Scarab"], ["holidayID"] = 638, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [16] = {["name"] = L["Hatching of the Hippogryphs"], ["holidayID"] = 634, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [17] = {["name"] = L["Un'Goro Madness"], ["holidayID"] = 644, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [18] = {["name"] = L["March of the Tadpoles"], ["holidayID"] = 647, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO}, 
    [19] = {["name"] = L["Volunteer Guard Day"], ["holidayID"] = 635, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [20] = {["name"] = L["Spring Balloon Festival"], ["holidayID"] = 645, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO}, 
    [21] = {["name"] = L["Glowcap Festival"], ["holidayID"] = 648, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [22] = {["name"] = L["Thousand Boat Bash"], ["holidayID"] = 642, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [23] = {["name"] = L["Luminous Luminaries"], ["holidayID"] = 1062, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [24] = {["name"] = L["Auction House Dance Party"], ["holidayID"] = 692, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [25] = {["name"] = L["Trial of Style"], ["holidayID"] = 691, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [26] = {["name"] = L["Great Gnomeregan Run"], ["holidayID"] = 696, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO},
    [27] = {["name"] = L["Moonkin Festival"], ["holidayID"] = 694, ["duration"] = EasyReminders.Data.Duration.ANNUAL, ["category"] = EasyReminders.Data.HolidayCategories.MICRO},

    -- Timewwalking
    [28] = {["name"] = L["Classic Timewalking"], ["holidayID"] = 1508, otherIds = {1583, 1584, 1585}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [29] = {["name"] = L["BC Timewalking"], ["holidayID"] = 559, otherIds = {622, 623, 624}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [30] = {["name"] = L["Wrath Timewalking"], ["holidayID"] = 562, otherIds = {616, 617, 618}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [31] = {["name"] = L["Cataclysm Timewalking"], ["holidayID"] = 587, otherIds = {628, 629, 630}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [32] = {["name"] = L["Mists Timewalking"], ["holidayID"] = 643, otherIds = {652, 654, 656}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [33] = {["name"] = L["Warlords Timewalking"], ["holidayID"] = 1056, otherIds = {1063, 1065, 1068}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [34] = {["name"] = L["Legion Timewalking"], ["holidayID"] = 1263, otherIds = {1265, 1267, 1269, 1271}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [35] = {["name"] = L["BfA Timewalking"], ["holidayID"] = 1666, otherIds = {1667, 1668, 1669}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},
    [36] = {["name"] = L["Shadowlands Timewalking"], ["holidayID"] = 1703, otherIds = {1704, 1705, 1706, 1707, 1708, 1709, 1710}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.TIMEWALKING},

    -- Brawels
    [37] = {["name"] = L["Brawl: Arathi Blizzard"], ["holidayID"] = 666, otherIds = {673, 680, 687, 737}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [38] = {["name"] = L["Brawl: Classic Ashran"], ["holidayID"] = 1120, otherIds = {1121, 1122, 1123, 1124}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [39] = {["name"] = L["Brawl: Comp Stomp"], ["holidayID"] = 1234, otherIds = {1235, 1236, 1237, 1238}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [40] = {["name"] = L["Brawl: Cooking Impossible"], ["holidayID"] = 1047, otherIds = {1048, 1049, 1050, 1051}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [41] = {["name"] = L["Brawl: Deep Six"], ["holidayID"] = 702, otherIds = {704, 105, 706, 736}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [42] = {["name"] = L["Brawl: Cooking Impossible"], ["holidayID"] = 1047, otherIds = {1048, 1049, 1050, 1051}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [43] = {["name"] = L["Brawl: Deepwind Dunk"], ["holidayID"] = 1239, otherIds = {1240, 1241, 1242, 1243}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [44] = {["name"] = L["Brawl: Gravity Lapse"], ["holidayID"] = 659, otherIds = {663, 670, 677, 684}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [45] = {["name"] = L["Brawl: Packed House"], ["holidayID"] = 667, otherIds = {674, 681, 688, 701}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [46] = {["name"] = L["Brawl: Shado-Pan Showdown"], ["holidayID"] = 1232, otherIds = {1233, 1244, 1245, 1246}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [47] = {["name"] = L["Brawl: Southore v Tarren Mill"], ["holidayID"] = 660, otherIds = {662, 669, 676, 683}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [48] = {["name"] = L["Brawl: Temple of Hotmogu"], ["holidayID"] = 1166, otherIds = {1167, 1168, 1168, 1170}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
    [49] = {["name"] = L["Brawl: Warsong Scramble"], ["holidayID"] = 664, otherIds = {671, 678, 685, 1221}, ["duration"] = EasyReminders.Data.Duration.MONTHLY, ["category"] = EasyReminders.Data.HolidayCategories.BRAWL},
}

