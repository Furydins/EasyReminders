EasyReminders.UI = EasyReminders.UI or {}
EasyReminders.UI.Options = EasyReminders.UI.Options or {}

local Options = EasyReminders.UI.Options

local L = LibStub("AceLocale-3.0"):GetLocale("EasyReminders")
EasyReminders.options = {}

-- function that draws the widgets for the first tab
function Options:GetOptions()

  local optionsdb = EasyReminders.globalDB

  if optionsdb.minimap == nil then optionsdb.minimap = {} end

  local options = {
      name = L["Easy Reminders"],
      handler = EasyReminders.options,
      type = 'group',
      args = {
          minimapButton = {
              type = 'toggle',
              order = 1,
              name = "Hide Minimap Button",
              desc = "Toggle to hide the minimap button",
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
        },
      }
      return options
end
