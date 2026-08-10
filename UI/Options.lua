EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.Options = EasyReminders.UI.Options or {}

local Options = EasyReminders.UI.Options

local L = _G.LibStub("AceLocale-3.0"):GetLocale("EasyReminders")
EasyReminders.options = {}

-- function that draws the widgets for the first tab
function Options:GetOptions()

  local optionsdb = EasyReminders.globalDB

  if optionsdb.minimap == nil then optionsdb.minimap = {} end
  if optionsdb.anchor == nil then optionsdb.anchor = false end
  if optionsdb.lock == nil then optionsdb.lock = false end

  local options = {
      name = L["Easy Reminders"],
      handler = EasyReminders.options,
      type = 'group',
      args = {
          minimapButton = {
              type = 'toggle',
              order = 1,
              name = L["Hide Minimap Button"],
              desc = L["Toggle to hide the minimap button"],
              width = "full",
              get = function(info)  return optionsdb.minimap.hide end,
              set = function(info,val) if optionsdb.minimap.hide
                  then optionsdb.minimap.hide = false
                    EasyReminders.MinimapIcon:Show("EasyReminders")
                  else optionsdb.minimap.hide = true 
                    EasyReminders.MinimapIcon:Hide("EasyReminders")
                  end
                end,
          },
          legacyDungeon = {
              type = 'toggle',
              order = 2,
              name = L["Ignore Legacy Dungeons"],
              desc = L["When enabled will not show reminders for dungeons where legacy loot mode is enabled"],
              width = "full",
              get = function(info)  return optionsdb.ignoreLegacyDungeons end,
              set = function(info,val) if optionsdb.ignoreLegacyDungeons
                  then optionsdb.ignoreLegacyDungeons = false
                  else optionsdb.ignoreLegacyDungeons = true 
                  end
                  EasyReminders:CheckBuffs("REFRESH")
                end,
          },
          legacy = {
              type = 'toggle',
              order = 3,
              name = L["Ignore Legacy Raids"],
              desc = L["When enabled will not show reminders for raids where legacy loot mode is enabled"],
              width = "full",
              get = function(info)  return optionsdb.ignoreLegacyRaids end,
              set = function(info,val) if optionsdb.ignoreLegacyRaids
                  then optionsdb.ignoreLegacyRaids = false
                  else optionsdb.ignoreLegacyRaids = true 
                  end
                  EasyReminders:CheckBuffs("REFRESH")
                end,
          },
          dungeon = {
              type = 'select',
              order = 4,
              name = L["Minimum Dungeon Difficulty"],
              desc = L["Ignore dungeons below the selected diffculty"],
              values = { ["NORMAL"] = L["Normal"], ["HEROIC"] = L["Heroic"], ["MYTHIC"] = L["Mythic"], ["MYTHIC_SEASONAL"] = L["Mythic (Seasonal)"] },
              sorting = { "NORMAL", "HEROIC", "MYTHIC", "MYTHIC_SEASONAL" },
              style = "dropdown",
              width = "normal",
              get = function(info)  return EasyReminders.globalDB.minimumDungeonDifficulty end,
              set = function(info,val) 
                    EasyReminders.globalDB.minimumDungeonDifficulty = val
                    EasyReminders:CheckBuffs("REFRESH")
                  end,
            },
            raid = {
              type = 'select',
              order = 5,
              name = L["Minimum Raid Difficulty"],
              desc = L["Ignore raids below the selected diffculty"],
              values = { ["LFR"] = L["LFR"], ["NORMAL"] = L["Normal"], ["HEROIC"] = L["Heroic"], ["MYTHIC"] = L["Mythic"] },
              sorting = { "LFR", "NORMAL", "HEROIC", "MYTHIC" },
              style = "dropdown",
              width = "normal",
              get = function(info)  return EasyReminders.globalDB.minimumRaidDifficulty end,
              set = function(info,val) 
                    EasyReminders.globalDB.minimumRaidDifficulty = val
                    EasyReminders:CheckBuffs("REFRESH")
                  end,
          },
           header3 = {
              type = 'header',
              order = 6,
              name = L["Display"],
          },
          anchor = {
              type = 'toggle',
              order = 7,
              name = L["Show Notification Anchor"],
              desc = L["Shows a visible anchor to make moving the notification frame easier"],
              width = "full",
              get = function(info)  return optionsdb.anchor end,
              set = function(info,val) if optionsdb.anchor
                  then optionsdb.anchor = false
                  else optionsdb.anchor = true 
                  end
                  EasyReminders:CheckBuffs("REFRESH")
                end,
          },
          lock = {
              type = 'toggle',
              order = 8,
              name = L["Lock Notification Window"],
              desc = L["Prevents movement of the bar"],
              width = "full",
              get = function(info)  return optionsdb.lock end,
              set = function(info,val) if optionsdb.lock
                  then optionsdb.lock = false
                  else optionsdb.lock = true 
                  end
                  EasyReminders:CheckBuffs("REFRESH")
                end,
          },
          outline = {
              type = 'select',
              order = 9,
              name = L["Orientation"],
              desc = L["Controls the direction the notifications will grow"],
              values = { ["VERTICAL"] = L["Vertical"], ["HORIZONTAL"] = L["Horizontal"] },
              style = "dropdown",
              width = "normal",
              get = function(info)  return EasyReminders.globalDB.orientation end,
              set = function(info,val) 
                      if val == "NONE" then
                          EasyReminders.globalDB.orientation = nil
                      else
                          EasyReminders.globalDB.orientation = val
                      end
                      EasyReminders.UI.NotificationWindow:ChangeOrientation(EasyReminders.globalDB.orientation)
                  end,
          },
          header3 = {
              type = 'header',
              order = 10,
              name = L["Debug"],
          },
           resetPos = {
                order = 11,
                type = "execute",
                name = L["Reset Holidays"],
                desc = L["Restores dismissed holidays and group events"],
                func =  function (info)
                            EasyReminders.UI.HolidayWindow:ResetReminders()
                        end
            },
        },
      }
    return options
end
