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
          anchor = {
              type = 'toggle',
              order = 2,
              name = L["Show Notification Anchor"],
              desc = L["Shows a visible anchor to make moving the notification frame easier"],
              width = "full",
              get = function(info)  return optionsdb.anchor end,
              set = function(info,val) if optionsdb.anchor
                  then optionsdb.anchor = false
                  else optionsdb.anchor = true 
                  end
                  EasyReminders:CheckBuffs()
                end,
          },
          lock = {
              type = 'toggle',
              order = 3,
              name = L["Lock Notification Window"],
              desc = L["Prevents movement of the bar"],
              width = "full",
              get = function(info)  return optionsdb.lock end,
              set = function(info,val) if optionsdb.lock
                  then optionsdb.lock = false
                  else optionsdb.lock = true 
                  end
                  EasyReminders:CheckBuffs()
                end,
          },
          header3 = {
              type = 'header',
              order = 4,
              name = L["Display"],
          },
          outline = {
              type = 'select',
              order = 5,
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
        },
        
      }
      return options
end
