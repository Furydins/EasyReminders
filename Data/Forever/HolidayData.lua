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
    -- Next free i: 58

    [1] = {["name"] = L["Darkmoon Faire"], ["holidayID"] = 479,  ["category"] = EasyReminders.Data.HolidayCategories.OTHER},

    [2] = {["name"] = L["Lunar Festival"], ["holidayID"] = 327,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [3] = {["name"] = L["Love is in the Air"], ["holidayID"] = 423,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [4] = {["name"] = L["Noblegarden"], ["holidayID"] = 181,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [5] = {["name"] = L["Children's Week"], ["holidayID"] = 201,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR}, -- Missing
    [6] = {["name"] = L["Midsummer Fire Festival"], ["holidayID"] = 341,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [7] = {["name"] = L["Pirates' Day"], ["holidayID"] = 398,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR}, -- Missing
    [8] = {["name"] = L["Brewfest"], ["holidayID"] = 372,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR}, -- Missing
    [9] = {["name"] = L["Harvest Festival"], ["holidayID"] = 321,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [10] = {["name"] = L["Hallow's End"], ["holidayID"] = 324,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    [11] = {["name"] = L["Day of the Dead"], ["holidayID"] = 409,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR}, -- Missing
    [12] = {["name"] = L["Anniversary Event"], ["holidayID"] = 1808,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR}, 
    [13] = {["name"] = L["Pilgrim's Bounty"], ["holidayID"] = 404,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR}, -- Missing
    [14] = {["name"] = L["Feast of Winter Veil"], ["holidayID"] = 141,  ["category"] = EasyReminders.Data.HolidayCategories.MAJOR},
    

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


}
