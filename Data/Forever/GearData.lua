EasyReminders.Data = EasyReminders.Data or {}

EasyReminders.Data.GearSlots = {

    -- gear slots for checking missing enchants/gems

    [1] = {["slotID"] = 1, ["slotName"] = _G.HEADSLOT, ["slotNameID"] = "HEADSLOT"},
    [2] = {["slotID"] = 2, ["slotName"] = _G.NECKSLOT, ["slotNameID"] = "NECKSLOT", ["enchantable"] = true},
    [3] = {["slotID"] = 3, ["slotName"] = _G.SHOULDERSLOT, ["slotNameID"] = "SHOULDERSLOT"},
    [4] = {["slotID"] = 4, ["slotName"] = _G.SHIRTSLOT, ["slotNameID"] = "SHIRTSLOT"},
    [5] = {["slotID"] = 5, ["slotName"] = _G.CHESTSLOT, ["slotNameID"] = "CHESTSLOT", ["enchantable"] = true},
    [6] = {["slotID"] = 6, ["slotName"] = _G.WAISTSLOT, ["slotNameID"] = "WAISTSLOT"},
    [7] = {["slotID"] = 7, ["slotName"] = _G.LEGSSLOT, ["slotNameID"] = "LEGSSLOT",},
    [8] = {["slotID"] = 8, ["slotName"] = _G.FEETSLOT, ["slotNameID"] = "FEETSLOT", ["enchantable"] = true},
    [9] = {["slotID"] = 9, ["slotName"] = _G.WRISTSLOT, ["slotNameID"] = "WRISTSLOT", ["enchantable"] = true},
    [10] = {["slotID"] = 10, ["slotName"] = _G.HANDSSLOT, ["slotNameID"] = "HANDSSLOT", ["enchantable"] = true},
    [11] = {["slotID"] = 11, ["slotName"] = _G.FINGER0SLOT, ["slotNameID"] = "FINGER0SLOT", },
    [12] = {["slotID"] = 12, ["slotName"] = _G.FINGER1SLOT, ["slotNameID"] = "FINGER1SLOT", },
    [13] = {["slotID"] = 13, ["slotName"] = _G.TRINKET0SLOT, ["slotNameID"] = "TRINKET0SLOT"},
    [14] = {["slotID"] = 14, ["slotName"] = _G.TRINKET1SLOT, ["slotNameID"] = "TRINKET1SLOT"},
    [15] = {["slotID"] = 15, ["slotName"] = _G.BACKSLOT, ["slotNameID"] = "BACKSLOT", ["enchantable"] = true},
    [16] = {["slotID"] = 16, ["slotName"] = _G.MAINHANDSLOT, ["slotNameID"] = "MAINHANDSLOT", ["enchantable"] = true},
    [17] = {["slotID"] = 17, ["slotName"] = _G.SECONDARYHANDSLOT, ["slotNameID"] = "SECONDARYHANDSLOT", ["enchantable"] = true},
}

EasyReminders.Data.GearConsumables = {
    [20744] = {["itemID"] = 20744, ["slotID"] = 16, ["buffIDs"] = {2623}}, --  Minor Wizard Oil
    [20746] = {["itemID"] = 20746, ["slotID"] = 16, ["buffIDs"] = {2626}}, --  Lesser Wizard Oil
    [20749] = {["itemID"] = 20749, ["slotID"] = 16, ["buffIDs"] = {2628}}, --  Brilliant Wizard Oil
    [20745] = {["itemID"] = 20745, ["slotID"] = 16, ["buffIDs"] = {2624}}, --  Minor Mana Oil
    [20747] = {["itemID"] = 20747, ["slotID"] = 16, ["buffIDs"] = {2625}}, --  Lesser Mana Oil
    [20748] = {["itemID"] = 20748, ["slotID"] = 16, ["buffIDs"] = {2629}}, --  Brilliant Mana Oil

    [3824] = {["itemID"] = 3824, ["slotID"] = 16, ["buffIDs"] = {25}}, --  Shadow Oil
    [3829] = {["itemID"] = 3829, ["slotID"] = 16, ["buffIDs"] = {26}}, --  Frost Oil

    [232611] = {["itemID"] = 232611, ["slotID"] = 17, ["buffIDs"] = {7644}}, --  Magnificent Trollshine
    [228980] = {["itemID"] = 228980, ["slotID"] = 17, ["buffIDs"] = {7602}}, --  Conductive Shield Coating

    [2862] = {["itemID"] = 2862, ["slotID"] = 17, ["buffIDs"] = {40}, ["otherIds"] = {287978}}, --  Rough Sharpening Stone
    [2863] = {["itemID"] = 2863, ["slotID"] = 17, ["buffIDs"] = {13}}, --  Coarse Sharpening Stone
    [2871] = {["itemID"] = 2871, ["slotID"] = 17, ["buffIDs"] = {14}}, --  Heavy Sharpening Stone
    [12404] = {["itemID"] = 12404, ["slotID"] = 17, ["buffIDs"] = {1443}}, --  Dense Sharpening Stone
    [18262] = {["itemID"] = 18262, ["slotID"] = 17, ["buffIDs"] = {2506}, ["otherIds"] = {287980}}, --  Elemental Sharpening Stone
    [211845] = {["itemID"] = 211845, ["slotID"] = 17, ["buffIDs"] = {7089}}, --  Blackfathom Sharpening Stone
    [7964] = {["itemID"] = 7964, ["slotID"] = 17, ["buffIDs"] = {483}}, --  Solid Sharpening Stone
    [3239] = {["itemID"] = 3239, ["slotID"] = 17, ["buffIDs"] = {19}}, --  Rough Weightstone
    [3240] = {["itemID"] = 3240, ["slotID"] = 17, ["buffIDs"] = {20}}, --  Coarse Weightstone
    [3241] = {["itemID"] = 3241, ["slotID"] = 17, ["buffIDs"] = {21},}, --  Heavy Weightstone
    [7965] = {["itemID"] = 7965, ["slotID"] = 17, ["buffIDs"] = {3484}}, --  Solid Weightstone
    [12643] = {["itemID"] = 12643, ["slotID"] = 17, ["buffIDs"] = {1703}}, --  Dense Weightstone

    -- Drops
    [275067] = {["itemID"] = 275067, ["slotID"] = 17, ["buffIDs"] = {8698}}, -- Scroll of Imbue CHillknife
    [274947] = {["itemID"] = 274947, ["slotID"] = 17, ["buffIDs"] = {8700}}, -- Scroll of Imbue Lesser Flame

}

EasyReminders.Data.ClassEnchants = {
    -- Info from SpellItemEnchantment
    -- Rogue
    [8679] = {["buffID"] = 323, ["otherIds"] = {324,325,623,624,625}, ["spellID"] = 8679, ["slotIDs"] = {16,17}, ["class"] = "ROGUE"}, -- Instant Poison
    [3408] = {["buffID"] = 22, ["otherIds"] = {603}, ["spellID"] = 3408, ["slotIDs"] = {16,17}, ["class"] = "ROGUE"}, -- Crippling Poison
    [5761] = {["buffID"] = 35, ["otherIds"] = {23,643}, ["spellID"] = 5761, ["slotIDs"] = {16,17}, ["class"] = "ROGUE"}, --  Mind Numbing Poison
    [2823] = {["buffID"] = 7, ["otherIds"] = {8,626, 627, 2630}, ["spellID"] = 2823, ["slotIDs"] = {16,17}, ["class"] = "ROGUE"}, -- Deadly Poison
    [13219] = {["buffID"] = 703, ["otherIds"] = {704,705, 706}, ["spellID"] = 13219, ["slotIDs"] = {16,17}, ["class"] = "ROGUE"}, -- Wound Poison

}

EasyReminders.Data.GearSlotsNames = {
    [16] = L["Main Hand"],
    [17] = L["Off Hand"],
}
