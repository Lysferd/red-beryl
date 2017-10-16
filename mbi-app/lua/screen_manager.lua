
require('lua.screen.patient_list')

ScreenManager = { }
ScreenManager.__index = ScreenManager

function ScreenManager.new()
  local obj = setmetatable( { }, ScreenManager )

  obj.current_screen = nil

  return obj
end
