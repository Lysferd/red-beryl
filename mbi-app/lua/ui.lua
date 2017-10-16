
UI = {}
UI.__index = UI

function UI.new()
  local obj = setmetatable( {}, UI )

  TITLE_FONT = love.graphics.newFont('fonts/Arial.ttf', 30)

  -- HEADER
  local w = WINDOW_WIDTH
  local h = WINDOW_HEIGHT * 0.1
  local _w = 52
  local _h = 52
  local x = w - _w / 2 - 16

  obj.title_canvas = love.graphics.newCanvas(w, h)
  obj.add_button = Button.new(x, h / 2, _w, _h, 'icons/add_white.png')
  obj.search_button = Button.new(x - _w - 16, h / 2, _w, _h, 'icons/search_white.png')

  -- CONTENTS
  obj.content_x = 0
  obj.content_y = h
  h = WINDOW_HEIGHT * 0.9
  obj.content_canvas = love.graphics.newCanvas(w, h)

  obj:refresh()

  return obj
end

function UI:update()
  self.add_button:update()
  self.search_button:update()
end

function UI:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(self.title_canvas)
  self.add_button:draw()
  self.search_button:draw()

  love.graphics.draw(self.content_canvas, self.content_x, self.content_y)
end

function UI:refresh()
  love.graphics.setCanvas(self.title_canvas)

  love.graphics.clear()
  love.graphics.setBlendMode('alpha')
  love.graphics.setFont(TITLE_FONT)

  -- UI Title Background
  local w = WINDOW_WIDTH
  local h = WINDOW_HEIGHT * 0.1
  love.graphics.setColor(Colors.lightgray)
  love.graphics.rectangle('fill', 0, 0, w, h)

  -- UI Title Bottom Margin Line
  local x = WINDOW_WIDTH
  local y = WINDOW_HEIGHT * 0.1 - 1
  love.graphics.setColor(Colors.gray)
  love.graphics.line(0, y, x, y)

  -- UI Title Name
  local x = 20
  local y = h / 2 - TITLE_FONT:getHeight() / 2
  love.graphics.setColor(Colors.black)
  love.graphics.print("Pacientes", x, y)

  love.graphics.setCanvas(self.content_canvas)
  love.graphics.setFont(SMALL_FONT)
  --love.graphics.setColor(255, 0, 0)
  --love.graphics.rectangle('fill', 0, 0, self.content_canvas:getWidth(), self.content_canvas:getHeight())
  local y = 8
  for i = 1, #PATIENT_LIST do
    love.graphics.print(PATIENT_LIST[i], 8, y)
    y = y + SMALL_FONT:getHeight() + 2
  end

  love.graphics.setCanvas()
end
