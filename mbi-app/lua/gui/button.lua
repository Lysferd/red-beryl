
Button = {}
Button.__index = Button

function Button.new(x, y, w, h, source)
  local obj = setmetatable( {}, Button )

  obj.parent_canvas = parent_canvas
  obj.color = Colors.lightblue

  obj.source = source
  obj.image = love.graphics.newImage(source, {linear = true, mipmaps = true})
  obj.ow = obj.image:getWidth()
  obj.oh = obj.image:getHeight()
  obj.w = w
  obj.h = h
  obj.sw = obj.w / obj.ow
  obj.sh = obj.h / obj.oh
  obj.x = x
  obj.y = y
  obj.ox = x - obj.w / 2
  obj.oy = y - obj.h / 2
  obj.canvas = love.graphics.newCanvas(obj.w, obj.h)

  obj.active = false

  obj:refresh()

  return obj
end

function Button:update()
  if within_area(self.x, self.y, self.w, self.h) then
    self.active = true
  else
    self.active = false
  end

  if self.active and love.mouse.isDown(1) then
    
  end
end

function Button:draw()
  if self.active then
    love.graphics.setColor(0, 255, 0, 255)
  else
    love.graphics.setColor(255, 255, 255, 255)
  end

  love.graphics.draw(self.canvas, self.ox, self.oy)
end

function Button:refresh()
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear()
  love.graphics.setBlendMode('alpha')

  love.graphics.setColor(Colors.lightgray)
  love.graphics.rectangle('fill', 0, 0, self.w, self.h)

  love.graphics.setColor(self.color)
  love.graphics.draw(self.image, 0, 0, 0, self.sw, self.sh)

  love.graphics.setCanvas()
end
