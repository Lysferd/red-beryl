
require('lua.sqlite3')

require('lua.ui')
require('lua.assets.button')

function love.load()
  --
  PATIENT_LIST = {}
  local hDB = sqlite3.open("data/db");
  if hDB then
    --local sQuery = "CREATE TABLE patients (name CHAR(20));"
    --hDB:execute(sQuery)
    --sQuery = "INSERT INTO patients (name) VALUES ('Varg Vilkernes')," ..
    --         "('Celestina Weishaupt'), ('Lyman Horta'), ('Vance Teran')," ..
    --         "('Elva Melnick');"
    --hDB:execute(sQuery)
    local query = "SELECT * FROM patients;"
    hDB:execute(query, showrow, 'testing')
    hDB:close()
  end
  --]]

  -- CONSTANTS
  STD_FONT      = love.graphics.newFont('fonts/Arial.ttf', 12)
  SMALL_FONT    = love.graphics.newFont('fonts/msgothic.ttc', 10)
  WINDOW_WIDTH  = love.graphics.getWidth()
  WINDOW_HEIGHT = love.graphics.getHeight()
  Colors = { white     = { 255, 255, 255 },
             black     = { 0, 0, 0 },
             lightgray = { 247, 247, 247 },
             gray      = { 178, 178, 178 },
             lightblue = { 3, 123, 251 } }

  -- STARTUP
  love.window.setTitle(love.window.getTitle() .. love.system.getOS())
  love.graphics.setBackgroundColor(Colors.white)

  -- CANVASES
  ui = UI.new()
end

function showrow(udata,cols,values,names)
  assert(udata=='testing')
  print('exec:')
  for i = 1, cols do
    print('', names[i], values[i])
    table.insert( PATIENT_LIST, values[i] )
  end
  return 0
end


function love.update()
  ui:update()
end

function love.draw()
  -- Draw UI
  ui:draw()

  -- Draw Debug
  love.graphics.setFont(SMALL_FONT)
  love.graphics.setColor(Colors.black)

  local x, y = love.mouse.getPosition()
  local mouse_position = 'Mouse cursor position: ' .. x .. 'x' .. y
  love.graphics.print( mouse_position, 1, WINDOW_HEIGHT - SMALL_FONT:getHeight() - 1 )

  local mouse_button
  if love.mouse.isDown(1) then
    mouse_button = "Left mouse button is PRESSED"
  else
    mouse_button = "Left mouse button is RELEASED"
  end
  love.graphics.print(mouse_button, WINDOW_WIDTH - SMALL_FONT:getWidth(mouse_button) - 1, WINDOW_HEIGHT - SMALL_FONT:getHeight() * 2 - 1 )

  if love.mouse.isDown(2) then
    mouse_button = "Right mouse button is PRESSED"
  else
    mouse_button = "Right mouse button is RELEASED"
  end
  love.graphics.print(mouse_button, WINDOW_WIDTH - SMALL_FONT:getWidth(mouse_button) - 1, WINDOW_HEIGHT - SMALL_FONT:getHeight() - 1 )
end

function love.keypressed( key, isrepeat )
  if key == 'escape' then
    love.event.quit(0)
  end
end

function within_area( x, y, w, h )
  local mx, my = love.mouse.getPosition()
  return mx >= x - w / 2 and
    mx <= x + w / 2 and
    my >= y - h / 2 and
    my <= y + h / 2
end
