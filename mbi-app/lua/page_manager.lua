
-- require('lua.pages.patient_list')
-- require('lua.pages.examination')
-- require('lua.pages.settings')

PageManager = Class('PageManager')

function ScreenManager:initialize()
  obj.index = 0
  obj.pages = { } -- page table
end
